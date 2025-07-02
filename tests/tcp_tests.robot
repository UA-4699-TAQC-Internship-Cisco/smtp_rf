*** Settings ***
Resource   resources/tcp_keywords.robot
Resource   resources/get_env.robot

*** Variables ***
${WRONG_PORT_INT}    9999

*** Test Cases ***
Connection To Invalid Port
    Load Environment Variables
    [Documentation]    Verify that connecting to a non-SMTP port results in connection refusal or timeout.
    ${timeout}=    Run Keyword If    '${TCP_TIMEOUT}' == ''    5    ELSE    Convert To Integer    ${TCP_TIMEOUT}
    ${result}=    Connect To Invalid Port Keyword    ${HOST}    ${WRONG_PORT_INT}    ${TCP_TIMEOUT}
    Should Be Equal As Strings    ${result}    CONNECTION_FAILED

HELO Command Response
    Load Environment Variables
    [Documentation]    Verify server responds with 250 greeting to HELO command.
    ${result}=    Check HELO Command Response    ${HOST}    ${PORT_INT}
    Should Be Equal As Strings    ${result}    HELO_OK