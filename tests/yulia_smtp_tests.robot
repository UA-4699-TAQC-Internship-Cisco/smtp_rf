*** Settings ***
Library    ../libraries/yulia_smtp_library.py
Resource   ../resources/yulia_smtp_keywords.robot
Resource   ../resources/get_env.robot

*** Test Cases ***
Connection To Invalid Port
    Load Environment Variables
    [Documentation]    Verify that connecting to a non-SMTP port results in connection refusal or timeout.
    ${timeout}=    Run Keyword If    '${TCP_TIMEOUT}' == ''    5    ELSE    Convert To Integer    ${TCP_TIMEOUT}
    ${result}=    Connect To Invalid Port Keyword    ${HOST}    ${WRONG_PORT_INT}    ${TCP_TIMEOUT}
    Should Be Equal As Strings    ${result}    CONNECTION_FAILED

Send Email With Headers Only
    Load Environment Variables
    [Documentation]    Verify sending email with headers only and no body.
    ${result}=    Send Email With Headers Only    ${SENDER}    ${RECIPIENT}    ${SUBJECT}    ${HOST}    ${PORT_INT}
    Should Be Equal As Strings    ${result}    EMAIL_SENT

Sending DATA Without RCPT TO
    Load Environment Variables
    [Documentation]    Verify that DATA is rejected if no RCPT TO command was sent.
    ${result}=    Send Data Without Rcpt To    ${SENDER}    ${HOST}    ${PORT_INT}
    Should Be Equal As Strings    ${result}    REJECTED

HELO Command Response
    Load Environment Variables
    [Documentation]    Verify server responds with 250 greeting to HELO command.
    ${result}=    Check HELO Command Response    ${HOST}    ${PORT_INT}
    Should Be Equal As Strings    ${result}    HELO_OK