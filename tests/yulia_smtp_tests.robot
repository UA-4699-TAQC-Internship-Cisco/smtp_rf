*** Settings ***
Library    ../libraries/yulia_smtp_library.py
Resource   ../resources/yulia_smtp_keywords.robot
Resource   ../resources/get_env.robot

*** Test Cases ***
Connection To Invalid Port
    Load Environment Variables
    ${timeout}=    Run Keyword If    '${TCP_TIMEOUT}' == ''    5    ELSE    Convert To Integer    ${TCP_TIMEOUT}
    ${result}=    Connect To Invalid Port Keyword    ${HOST}    ${WRONG_PORT_INT}    ${timeout}
    Should Be Equal As Strings    ${result}    CONNECTION_FAILED
