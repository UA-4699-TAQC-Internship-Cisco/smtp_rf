*** Settings ***
Library    OperatingSystem
Library    ../libraries/load_env.py

*** Keywords ***
Load Environment Variables
    Load Envs
    ${HOST}=    Get Environment Variable    HOSTNAME         #ok
    ${PORT}=    Get Environment Variable    SMTP_PORT    #ok
    ${PORT_INT}=    Evaluate    int(${PORT})    #ok
    ${TLS_PORT}=    Get Environment Variable    TLS_PORT    #ok
    ${TLS_PORT_INT}=    Evaluate    int(${TLS_PORT})    #ok
    ${IMAP_PORT}=    Get Environment Variable    IMAP_PORT    #ok
    ${IMAP_PORT_INT}=    Evaluate    int(${IMAP_PORT})    #ok

    ${USER}=    Get Environment Variable    SSH_USERNAME     #ok
    ${PASS}=    Get Environment Variable    SSH_PASSWORD     #ok

    ${USERNAME}=    Get Environment Variable    EMAIL_ACCOUNT     #ok
    ${EMAIL_PASSWORD}=    Get Environment Variable    EMAIL_PASSWORD    #ok
    ${WRONG_ACCOUNT}=    Get Environment Variable    WRONG_ACCOUNT    #ok
    ${EHLO_DOMAIN}=    Get Environment Variable    EHLO_DOMAIN    #ok
    
    ${TEST_USER}=    Get Environment Variable    TEST_USER
    ${TEST_PASS}=    Get Environment Variable    TEST_PASS

    ${TCP_TIMEOUT}=    Get Environment Variable    TCP_TIMEOUT    #ok
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
    Set Suite Variable    ${EHLO_DOMAIN}
    Set Suite Variable    ${TEST_USER}
    Set Suite Variable    ${TEST_PASS}





