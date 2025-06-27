*** Settings ***
Library    ../libraries/yulia_smtp_library.py
Resource   ../resources/yulia_smtp_keywords.robot
Resource   ../resources/get_env.robot

*** Test Cases ***
Connection To Invalid Port
    Load Environment Variables
    ${timeout}=    Run Keyword If    '${TCP_TIMEOUT}' == ''    5    ELSE    Convert To Integer    ${TCP_TIMEOUT}
    ${result}=    Connect To Invalid Port Keyword    ${HOST}    ${WRONG_PORT_INT}    ${TCP_TIMEOUT}
    Should Be Equal As Strings    ${result}    CONNECTION_FAILED

Send Email With Headers Only
    Load Environment Variables
    [Documentation]    Verify sending email with headers only and no body.
    ${result}=    Send Email With Headers Only    ${SENDER}    ${RECIPIENT}    ${SUBJECT}    ${HOST}    ${PORT_INT}
    Should Be Equal As Strings    ${result}    EMAIL_SENT
