*** Settings ***
Resource   ../resources/smtp_keywords.robot
Resource   ../resources/get_env.robot

*** Variables ***
${SUBJECT}    Test email

*** Test Cases ***

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