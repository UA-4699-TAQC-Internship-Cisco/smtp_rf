*** Settings ***
Library    ../libraries/smtp_library.py
Resource    ../resources/get_env.robot

*** Test Cases ***
TC007: Successful Authentication (AUTH LOGIN)

    Load Environment Variables

    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${ehlo_domain}=    Get Environment Variable    EHLO_DOMAIN
    ${username}=    Get Environment Variable    EMAIL_ACCOUNT
    ${email_password}=    Get Environment Variable    EMAIL_PASSWORD

    Open Smtp Connection    ${HOST}    ${PORT}
    ${banner}=    Read Smtp Banner  220
    Log    Server banner: ${banner}
    Should Contain    ${banner}  220

Send the EHLO example.com
    Send Smtp Command        EHLO ${ehlo_domain}
    ${ehlo_resp}=           Read Smtp Banner            250
    Log                    EHLO response: ${ehlo_resp}
    Should Contain          ${ehlo_resp}    250

Send the AUTH LOGIN command
    Send Smtp Command        AUTH LOGIN
    ${auth_resp}=           Read Smtp Banner       334
    Log                    AUTH LOGIN response: ${auth_resp}
    Should Contain          ${auth_resp}    334

Send the base64 encoded username
    ${username_b64}=        Encode String To Base64    ${username}
    Send Smtp Command        ${username_b64}
    ${user_resp}=           Read Smtp Banner        334
    Log                    Username response: ${user_resp}
    Should Contain          ${user_resp}    334

Send the base64 encoded password
    ${password_b64}=        Encode String To Base64    ${email_password}
    Send Smtp Command        ${password_b64}
    ${pass_resp}=           Read Smtp Banner        235
    Log                    Password response: ${pass_resp}
    Should Contain          ${pass_resp}    235 2.7.0 Authentication successful

    Close Smtp Connection
