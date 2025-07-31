*** Settings ***
Library           ../libraries/smtp_library.py
Resource          ../resources/get_env.robot

*** Test Cases ***
TC026: Accept Email From Safe List
    Load Environment Variables
    ${HOSTNAME}            Get Environment Variable    HOSTNAME
    ${SMTP_PORT}           Get Environment Variable    SMTP_PORT
    ${EHLO_DOMAIN}         Get Environment Variable    EHLO_DOMAIN
    ${REMOTE_RECIPIENT}    Get Environment Variable    REMOTE_RECIPIENT

    [Documentation]    Verify that mail from trusted@example.com (in Safe List) is accepted when content is clean
    [Tags]    safelist    smtp    positive

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
    Send Smtp Command    MAIL FROM:<trusted@email.com>
    ${mail_resp}=    Read Smtp Banner    250
    Should Contain    ${mail_resp}    250

    # Step 5: RCPT TO
    Send Smtp Command    RCPT TO:<${REMOTE_RECIPIENT}>
    ${rcpt_resp}=    Read Smtp Banner    250
    Should Contain    ${rcpt_resp}    250

    # Step 6: DATA
    Send Smtp Command    DATA
    ${data_resp}=    Read Smtp Banner    354
    Should Contain    ${data_resp}    354

    # Step 7: Send email body using keyword
    ${subject}=    Set Variable    Legitimate Email
    ${body}=       Set Variable    Hello,\nThis is a clean test message.\nRegards,\nTrusted sender
    Send Email Body    trusted@example.com    ${REMOTE_RECIPIENT}    ${subject}    ${body}

    # Step 8: Expect 250 after sending full message
    ${final_resp}=    Read Smtp Banner    250
    Should Contain    ${final_resp}    250

    # Step 9: QUIT
    Send Smtp Command    QUIT
    ${quit_resp}=    Read Smtp Banner    221
    Should Contain    ${quit_resp}    221

    # Step 10: Close connection
    Close Smtp Connection
