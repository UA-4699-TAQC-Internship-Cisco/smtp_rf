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
    Connect And Login    ${HOST}    ${PORT_INT}    ${USER}    ${PASS}
    Sleep    3s
    ${log}=    Read Log File    ${HOST}    ${USER}    ${PASS}
    Should Contain    ${log}    235 Authentication successful