*** Settings ***
Library    ../libraries/smtp_library.py
Resource    ../resources/get_env.robot

*** Variables ***
${rcpt_to}  external@otherdomain.com

*** Test Cases ***
TC010: Authentication Required for Relaying (Unauthenticated Attempt)

    Load Environment Variables

    ${HOST}=              Get Environment Variable    HOSTNAME
    ${PORT}=              Get Environment Variable    SMTP_PORT
    ${EHLO_DOMAIN}=       Get Environment Variable    EHLO_DOMAIN
    ${SENDER}=         Get Environment Variable    LOCAL_SENDER

# Step 1: Connect to SMTP server
    Open Smtp Connection    ${HOST}    ${PORT}
    ${banner}=              Read Smtp Banner    220
    Log                     Server banner: ${banner}
    Should Contain          ${banner}    220

# Step 2: Send EHLO
    Send Smtp Command       EHLO ${EHLO_DOMAIN}
    ${ehlo_resp}=           Read Smtp Banner    250
    Log                     EHLO response: ${ehlo_resp}
    Should Contain          ${ehlo_resp}    250

# Step 3: Send MAIL FROM (without AUTH)
    Send Smtp Command       MAIL FROM:<${SENDER}>
    ${mail_resp}=           Read Smtp Banner    250
    Log                     MAIL FROM response: ${mail_resp}
    Should Contain          ${mail_resp}    250

# Step 4: Send RCPT TO (to external domain)
    Send Smtp Command       RCPT TO:<${rcpt_to}>
    ${rcpt_resp}=           Read Smtp Banner    451
    Log                     RCPT TO response: ${rcpt_resp}
    Should Contain Any      ${rcpt_resp}    451    550    530



# Step 5: Close connection
    Close Smtp Connection
