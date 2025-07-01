*** Settings ***
Library    SSHLibrary
Library    OperatingSystem
Resource    resources/get_env.robot


*** Variables ***
${SMTP_PORT}       587


*** Test Cases ***
Verify Successful Connection And Initiation of TLS on the Submission Port
    Load Environment Variables
    Open Connection    ${HOST}
    Login              ${USER}    ${PASS}
Test TCP connectivity
    ${connection_result}=    Execute Command    nc -vz ${HOST} ${SMTP_PORT} 2>&1
    Log To Console      TCP Test:\n${connection_result}
    Should Contain    ${connection_result}    Connected to ${HOST}:${SMTP_PORT}

Send EHLO With Netcat
    ${cmd_ehlo}=    Set Variable    echo -e "EHLO ${HOST}\r\n" | nc ${HOST} ${SMTP_PORT}
    ${ehlo_result}=   Execute Command    ${cmd_ehlo}
    Log To Console      EHLO Output:\n${ehlo_result}
    Should Contain      ${ehlo_result}    250

Send the STARTTLS command.
    ${cmd_starttls}=    Set Variable    openssl s_client -starttls smtp -connect ${HOST}:${HOST} -verify_return_error
    ${rc}    ${startts_result}=   Run And Return Rc And Output    ${cmd_starttls}
    Should Contain    Return Code: ${rc}    Verify return code
    Should Not Contain    ${startts_result}    Connection refused
    Should Be Equal As Integers    ${rc}    0

    Close Connection
