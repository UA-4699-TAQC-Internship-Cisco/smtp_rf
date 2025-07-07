*** Settings ***
Resource    resources/common.robot
Resource    resources/get_env.robot

*** Variables ***
${INVALID_RCPT_NAME}=    user@nonexistingdom123.com

# Add smtpd_recipient_restrictions = reject_unauth_destinationto in /etc/postfix/main.cf
*** Test Cases ***
Handle Non Existing Rcpt Domain
    Load Environment Variables
    @{REPLY}=    Check Recipient Domain    ${HOST}    ${PORT_INT}    ${SENDER}    ${INVALID_RCPT_NAME}
    Should Be Equal    ${REPLY}[0]    ${554}
    Should Be Equal As Strings    ${REPLY}[1]    5.7.1 <${INVALID_RCPT_NAME}>: Relay access denied
