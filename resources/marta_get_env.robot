*** Settings ***
Library    OperatingSystem
Library    ../libraries/load_env.py

*** Keywords ***
Load Environment Variables
    [Arguments]    ${env_file}=None
    Load Envs    ${env_file}

    ${host}=    Get Environment Variable    HOST
    ${port}=    Get Environment Variable    SMTP_PORT
    ${tls_host}=    Get Environment Variable    TLS_HOST
    ${tls_port}=    Get Environment Variable    TLS_PORT
    ${from_addr}=    Get Environment Variable    FROM_ADDR
    ${to_addr}=    Get Environment Variable    TO_ADDR
    ${ehlo_domain}=    Get Environment Variable    EHLO_DOMAIN
    ${username}=    Get Environment Variable    EMAIL_ACCOUNT
    ${wrong_username}=    Get Environment Variable    WRONG_ACCOUNT
    ${email_password}=    Get Environment Variable    EMAIL_PASSWORD


    ${port_int}=    Evaluate    int(${port})
    ${tls_port_int}=    Evaluate    int(${tls_port})

    Log    Host: ${host}
    Log    Port: ${port_int}
    Log    From: ${from_addr}
    Log    To: ${to_addr}

    Set Suite Variable    ${HOST}    ${host}
    Set Suite Variable    ${PORT_INT}    ${port_int}
    Set Suite Variable    ${FROM_ADDR}    ${from_addr}
    Set Suite Variable    ${TO_ADDR}    ${to_addr}
    Set Suite Variable    ${EHLO_DOMAIN}    ${ehlo_domain}
    Set Suite Variable    ${USERNAME}    ${username}
    Set Suite Variable    ${WRONG_USERNAME}    ${wrong_username}
    Set Suite Variable    ${EMAIL_PASSWORD}    ${email_password}
    Set Suite Variable    ${TLS_HOST}    ${tls_host}
    Set Suite Variable    ${TLS_PORT_INT}    ${tls_port_int}
