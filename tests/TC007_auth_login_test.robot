*** Settings ***
Library    ../libraries/smtp_library.py
Resource    ../resources/get_env.robot

*** Test Cases ***
TC007: Successful Authentication (AUTH LOGIN)

    Load Environment Variables
    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${EHLO_DOMAIN}=    Get Environment Variable    EHLO_DOMAIN
    ${TEST_USER}=    Get Environment Variable    TEST_USER
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

Send the base64 encoded username
    ${username_b64}=        Encode String To Base64    ${TEST_USER}
    Send Smtp Command        ${username_b64}
    ${user_resp}=           Read Smtp Banner        334
    Log                    Username response: ${user_resp}
    Should Contain          ${user_resp}    334

Send the base64 encoded password
    ${password_b64}=        Encode String To Base64    ${TEST_PASS}
    Send Smtp Command        ${password_b64}
    ${pass_resp}=           Read Smtp Banner        235
    Log                    Password response: ${pass_resp}
    Should Contain          ${pass_resp}    235 2.7.0 Authentication successful

    Close Smtp Connection
