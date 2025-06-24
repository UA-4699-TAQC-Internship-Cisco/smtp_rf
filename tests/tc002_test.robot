*** Settings ***
Library    SSHLibrary
Library    OperatingSystem


*** Variables ***
${SMTP_PORT}       587 #______get from .env
${SMTP_HOST}       192.168.3.62 #______get from .env
${SMTP_USER}       ______get from .env
${SMTP_PASSWORD}   ______get from .env


*** Test Cases ***
Verify Successful Connection And Initiation of TLS on the Submission Port
    Open Connection    ${SMTP_HOST}
    Login              ${SMTP_USER}    ${SMTP_PASSWORD}
Test TCP connectivity
    ${connection_result}=    Execute Command    nc -vz ${SMTP_HOST} ${SMTP_PORT} 2>&1
    Log To Console      TCP Test:\n${connection_result}
    Should Contain    ${connection_result}    Connected to ${SMTP_HOST}:${SMTP_PORT}

Send EHLO With Netcat
    ${cmd_ehlo}=    Set Variable    echo -e "EHLO ${SMTP_HOST}\r\n" | nc ${SMTP_HOST} 587
    ${ehlo_result}=   Execute Command    ${cmd_ehlo}
    Log To Console      EHLO Output:\n${ehlo_result}
    Should Contain      ${ehlo_result}    250

Send the STARTTLS command.
    ${cmd_starttls}=    Set Variable    openssl s_client -starttls smtp -connect ${SMTP_HOST}:${SMTP_PORT} -verify_return_error
    ${rc}    ${startts_result}=   Run And Return Rc And Output    ${cmd_starttls}
    Log To Console      Return Code: ${rc}

    Should Contain    ${startts_result}    Verify return code
    Should Not Contain    ${startts_result}    Connection refused
    Should Be Equal As Integers    ${rc}    0

    Close Connection
