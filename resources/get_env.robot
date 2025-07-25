*** Settings ***
Library    OperatingSystem
Library    ../libraries/load_env.py

*** Keywords ***
Load Environment Variables
    Load Envs
    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${PORT_INT}=    Evaluate    int(${PORT})
    ${TLS_PORT}=    Get Environment Variable    TLS_PORT
    ${TLS_PORT_INT}=    Evaluate    int(${TLS_PORT})
    ${AUTH_PORT}=    Get Environment Variable    AUTH_PORT
    ${AUTH_PORT_INT}=    Evaluate    int(${AUTH_PORT})
    ${SSH_PORT}=    Get Environment Variable    SSH_PORT
    ${SSH_PORT_INT}=    Evaluate    int(${SSH_PORT})

    ${USER}=    Get Environment Variable    SSH_USERNAME
    ${PASS}=    Get Environment Variable    SSH_PASSWORD

    ${username}=    Get Environment Variable    EMAIL_ACCOUNT
    ${email_password}=    Get Environment Variable    EMAIL_PASSWORD
    ${wrong_username}=    Get Environment Variable    WRONG_ACCOUNT
    ${ehlo_domain}=    Get Environment Variable    EHLO_DOMAIN

    ${TCP_TIMEOUT}=    Get Environment Variable    TCP_TIMEOUT
    ${SENDER}=    Get Environment Variable    LOCAL_SENDER
    ${RECIPIENT}=    Get Environment Variable    REMOTE_RECIPIENT


    Log    Loaded host: ${HOST}
    Log    Port: ${PORT_INT}

    Set Suite Variable    ${HOST}
    Set Suite Variable    ${PORT_INT}
    Set Suite Variable    ${TLS_PORT}
    Set Suite Variable    ${TLS_PORT_INT}
    Set Suite Variable    ${AUTH_PORT}
    Set Suite Variable    ${AUTH_PORT_INT}
    Set Suite Variable    ${SSH_PORT}
    Set Suite Variable    ${SSH_PORT_INT}
    Set Suite Variable    ${TCP_TIMEOUT}
    Set Suite Variable    ${USER}
    Set Suite Variable    ${PASS}
    Set Suite Variable    ${username}
    Set Suite Variable    ${WRONG_USERNAME}    ${wrong_username}
    Set Suite Variable    ${SENDER}
    Set Suite Variable    ${RECIPIENT}
    Set Suite Variable    ${EHLO_DOMAIN}    ${ehlo_domain}
    Set Suite Variable    ${email_password}




