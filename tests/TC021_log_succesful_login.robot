*** Settings ***
Library           OperatingSystem
Library           SSHLibrary
Library           libraries/smtp_library.py
Resource          resources/get_env.robot

Test Setup        Load Environment Variables

*** Variables ***
${LOG_FILE}       /var/log/maillog
${AUTH_SUCCESS}   235 Authentication successful

*** Test Cases ***
TC021: Log Successful Login
    Load Environment Variables
    Connect To SMTP
    Authenticate SMTP User
    Sleep    3s
    ${log}=    Connect To SSH And Read Logs
    Should Contain    ${log}    235 Authentication successful


*** Keywords ***
Connect To SMTP
    Open Smtp Connection    ${HOST}    ${PORT_INT}

Authenticate SMTP User
    Send Smtp Command       EHLO ${EHLO_DOMAIN}
    Send Smtp Command       AUTH LOGIN
    ${username_b64}=        Encode String To Base64    ${username}
    Send Smtp Command       ${username_b64}
    ${password_b64}=        Encode String To Base64    ${email_password}
    Send Smtp Command       ${password_b64}

Connect To SSH And Read Logs
    Open Connection         ${HOST}    port=${SSH_PORT_INT}
    Login                   ${USER}    ${PASS}
    ${log}=                 Execute Command    sudo tail -n 10 /var/log/maillog
    [Return]                ${log}

