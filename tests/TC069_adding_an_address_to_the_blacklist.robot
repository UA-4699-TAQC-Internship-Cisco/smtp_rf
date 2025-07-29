*** Settings ***
Library           ../libraries/smtp_library.py
Resource          ../resources/get_env.robot

*** Test Cases ***
TC0069: Add address to blacklist
    [Documentation]    Verify that an email from blacklist@bad-domain.com is rejected after DATA via header_checks
    [Tags]    blacklist    smtp    header_checks    negative

    Load Environment Variables
    ${HOSTNAME}            Get Environment Variable    HOSTNAME
    ${SMTP_PORT}           Get Environment Variable    SMTP_PORT
    ${EHLO_DOMAIN}         Get Environment Variable    EHLO_DOMAIN
    ${REMOTE_RECIPIENT}    Get Environment Variable    REMOTE_RECIPIENT

    # Step 1: Connect to SMTP server
    Open Smtp Connection    ${HOSTNAME}    ${SMTP_PORT}

    # Step 2: Read 220 greeting
    ${banner}=    Read Smtp Banner    220
    Should Contain    ${banner}    220

    # Step 3: Send EHLO
    Send Smtp Command    EHLO ${EHLO_DOMAIN}
    ${ehlo_resp}=    Read Smtp Banner    250
    Should Contain    ${ehlo_resp}    250

    # Step 4: MAIL FROM
    Send Smtp Command    MAIL FROM:<blacklist@bad-domain.com>
    ${mail_resp}=    Read Smtp Banner    250
    Should Contain    ${mail_resp}    250

    # Step 5: RCPT TO
    Send Smtp Command    RCPT TO:<${REMOTE_RECIPIENT}>
    ${rcpt_resp}=    Read Smtp Banner    554 5.7.1
    Should Contain Any    ${rcpt_resp}    554 5.7.1    Sender address rejected: Access denied

    # Step 8: Close connection
    Close Smtp Connection
