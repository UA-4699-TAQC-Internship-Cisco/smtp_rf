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

Connect To Server Via SSH
    Open Connection    ${HOST}    port=22    timeout=30 seconds
    Login    ${USER}    ${PASS}
    ${output}=    Execute Command    whoami
    Log    ${output}
    Close Connection

TC021: Log Successful Login
    [Documentation]    Verify that user was authenticated by checking log for 235 code
    ${maillog}=         Read Logfile
    Should Contain      ${maillog}     ${AUTH_SUCCESS}


*** Keywords ***
Connect To SMTP And Authenticate
    Open Connection    ${HOST}    ${PORT_INT}
    Login              ${USER}    ${PASS}

Read Logfile
    [Documentation]    Connect via SSH and read maillog
    Open Connection    ${HOST}    ${SSH_PORT_INT}
    Login              ${USER}    ${PASS}
    ${log}=    Execute Command    sudo grep "${USER}" ${LOG_FILE}
    [Return]    ${log}