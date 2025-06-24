*** Settings ***
Library    SSHLibrary
Library    Process


*** Variables ***
${SMTP_PORT}    587
${SMTP_HOST}    192.168.3.62


*** Test Cases ***
Verify Successful Connection And Initiation of TLS on the Submission Port
    Open Connection    ${SMTP_HOST}
    Login              ${VM_USER}    ${PASSWORD}
    ${connection_result}=    Execute Command    nc -vz ${SMTP_HOST} ${SMTP_PORT}


Send EHLO With Netcat
    ${cmd_ehlo}=    Set Variable    echo -e "EHLO ${SMTP_HOST}\r\n" | nc ${SMTP_HOST} 587
    ${ehlo_result}=   Execute Command    ${cmd_ehlo}
    Log    ${ehlo_result}
    Log To Console      ${ehlo_result}

Send the STARTTLS command.
    ${cmd_startts}=    Set Variable    openssl    s_client    -starttls    smtp    -connect     ${SMTP_HOST}:587    -verify_return_error
    ${startts_result}=   Execute Command    ${cmd_startts}
   # Should Contain    ${startts_result.stdout}    220
   # Should Contain    ${startts_result.stdout}    Verify return code: 0 (ok)
    Log To Console      --------------

    Close Connection
