*** Settings ***
Library    ../libraries/smtp_library.py
Resource    ../resources/get_env.robot


*** Test Cases ***
TC009: Failed Authentication (Missing Credentials)

    Load Environment Variables

    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${ehlo_domain}=    Get Environment Variable    EHLO_DOMAIN
    ${wrong_username}=    Get Environment Variable    WRONG_ACCOUNT
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

Send wrong username
    ${username_b64}=    Encode String To Base64    ${wrong_username}
    Send Smtp Command    ${username_b64}
    ${pw_prompt}=       Read Smtp Banner           334
    Log                 Server asks for password: ${pw_prompt}
    Should Contain      ${pw_prompt}               334
    Sleep    2s

    ${password_b64}=    Encode String To Base64    ${email_password}
    Send Smtp Command    ${password_b64}
    ${auth_fail}=       Read Smtp Banner           535
    Log                 Auth fail response: ${auth_fail}
    Should Contain      ${auth_fail}               535 5.7.8

    Close Smtp Connection
