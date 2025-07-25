*** Settings ***
Resource    resources/common.robot
Resource    resources/get_env.robot

*** Variables ***
${INVALID_RCPT_NAME}=    user@nonexistingdom123.com

# Add the following lines in /etc/postfix/main.cf:
# smtpd_recipient_restrictions = permit_mynetworks
# smtpd_relay_restrictions = permit_sasl_authenticated, reject_unauth_destination

*** Test Cases ***
Handle Non Existing Rcpt Domain
    Load Environment Variables
    @{REPLY}=    Check Recipient Domain    ${HOST}    ${PORT_INT}    ${SENDER}    ${INVALID_RCPT_NAME}
    Set Suite Variable    @{REPLY}
    Should Be Equal    ${REPLY}[0]    ${554}

Verify Log Message
    ${LOG_CONTENT}=    Check Maillog    ${HOST}    ${USER}    ${PASS}
    Should Contain    ${LOG_CONTENT}    ${REPLY}[1]