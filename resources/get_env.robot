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
    ${IMAP_PORT}=    Get Environment Variable    IMAP_PORT    #ok
    ${IMAP_PORT_INT}=    Evaluate    int(${IMAP_PORT})    #ok

    ${USER}=    Get Environment Variable    SSH_USERNAME
    ${PASS}=    Get Environment Variable    SSH_PASSWORD

    ${USERNAME}=    Get Environment Variable    EMAIL_ACCOUNT
    ${EMAIL_PASSWORD}=    Get Environment Variable    EMAIL_PASSWORD
    ${WRONG_ACCOUNT}=    Get Environment Variable    WRONG_ACCOUNT
    ${EHLO_DOMAIN}=    Get Environment Variable    EHLO_DOMAIN

    ${TEST_USER}=    Get Environment Variable    TEST_USER
    ${TEST_PASS}=    Get Environment Variable    TEST_PASS

    ${TCP_TIMEOUT}=    Get Environment Variable    TCP_TIMEOUT
    ${SENDER}=    Get Environment Variable    LOCAL_SENDER
    ${RECIPIENT}=    Get Environment Variable    REMOTE_RECIPIENT


    Log    Loaded host: ${HOST}
    Log    Port: ${PORT_INT}
    Log    TLS Port: ${TLS_PORT_INT}
    Log    IMAP Port: ${IMAP_PORT_INT}

    Set Suite Variable    ${HOST}
    Set Suite Variable    ${PORT_INT}
    Set Suite Variable    ${TLS_PORT}
    Set Suite Variable    ${TLS_PORT_INT}
    Set Suite Variable    ${AUTH_PORT}
    Set Suite Variable    ${AUTH_PORT_INT}
    Set Suite Variable    ${SSH_PORT}
    Set Suite Variable    ${SSH_PORT_INT}
    Set Suite Variable    ${IMAP_PORT}
    Set Suite Variable    ${IMAP_PORT_INT}
    Set Suite Variable    ${TCP_TIMEOUT}
    Set Suite Variable    ${USER}
    Set Suite Variable    ${PASS}
    Set Suite Variable    ${USERNAME}
    Set Suite Variable    ${EMAIL_PASSWORD}
    Set Suite Variable    ${WRONG_ACCOUNT}
    Set Suite Variable    ${SENDER}
    Set Suite Variable    ${RECIPIENT}
    Set Suite Variable    ${EHLO_DOMAIN}    ${ehlo_domain}
    Set Suite Variable    ${email_password}
    Set Suite Variable    ${TEST_USER}
    Set Suite Variable    ${TEST_PASS}




