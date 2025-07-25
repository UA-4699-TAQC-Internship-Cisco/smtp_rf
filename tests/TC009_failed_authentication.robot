*** Settings ***
Library    ../libraries/smtp_library.py
Resource    ../resources/get_env.robot


*** Test Cases ***
TC009: Failed Authentication (Missing Credentials)

    Load Environment Variables

    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${EHLO_DOMAIN}=    Get Environment Variable    EHLO_DOMAIN
    ${WRONG_ACCOUNT}=    Get Environment Variable    WRONG_ACCOUNT
    ${TEST_PASS}=    Get Environment Variable    TEST_PASS


    Open Smtp Connection    ${HOST}    ${PORT}
    ${banner}=    Read Smtp Banner  220
    Log    Server banner: ${banner}
    Should Contain    ${banner}  220

Send the EHLO example.com
    Send Smtp Command        EHLO ${EHLO_DOMAIN}
    ${ehlo_resp}=           Read Smtp Banner            250
    Log                    EHLO response: ${ehlo_resp}
    Should Contain          ${ehlo_resp}    250

Send the AUTH LOGIN command
    Send Smtp Command        AUTH LOGIN
    ${auth_resp}=           Read Smtp Banner       334
    Log                    AUTH LOGIN response: ${auth_resp}
    Should Contain          ${auth_resp}    334

Send wrong username
    ${username_b64}=    Encode String To Base64    ${WRONG_ACCOUNT}
    Send Smtp Command    ${username_b64}
    ${pw_prompt}=       Read Smtp Banner           334
    Log                 Server asks for password: ${pw_prompt}
    Should Contain      ${pw_prompt}               334
    Sleep    2s

    ${password_b64}=    Encode String To Base64    ${TEST_PASS}
    Send Smtp Command    ${password_b64}
    ${auth_fail}=       Read Smtp Banner           535
    Log                 Auth fail response: ${auth_fail}
    Should Contain      ${auth_fail}               535 5.7.8

    Close Smtp Connection
