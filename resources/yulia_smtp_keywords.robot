*** Settings ***
Library    ../libraries/yulia_smtp_library.py
Resource   ../resources/get_env.robot

*** Keywords ***
Connect To Invalid Port Keyword
    [Arguments]    ${HOST}    ${WRONG_PORT_INT}    ${TCP_TIMEOUT}
    ${result}=    Connect To Invalid Port    ${HOST}    ${WRONG_PORT_INT}    ${TCP_TIMEOUT}
    [Return]    ${result}

Send Email With Headers Only
    [Arguments]    ${SENDER}    ${RECIPIENT}    ${SUBJECT}    ${HOST}    ${PORT_INT}
    ${result}=    Send Email Headers Only    ${SENDER}    ${RECIPIENT}    ${SUBJECT}    ${HOST}    ${PORT_INT}
    [Return]    ${result}