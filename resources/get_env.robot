*** Settings ***
Library    OperatingSystem
Library    ../libraries/load_env.py

*** Keywords ***
Load Environment Variables
    Load Envs
    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${PORT_INT}=    Evaluate    int(${PORT})
    ${WRONG_PORT}=    Get Environment Variable    WRONG_PORT
    ${WRONG_PORT_INT}=  Evaluate    int(${WRONG_PORT})
    ${USER}=    Get Environment Variable    SSH_USERNAME
    ${PASS}=    Get Environment Variable    PASSWORD
    ${TCP_TIMEOUT}=    Get Environment Variable    TCP_TIMEOUT

    Log    Loaded host: ${HOST}
    Log    Port: ${PORT_INT}

    Set Suite Variable    ${HOST}
    Set Suite Variable    ${PORT_INT}
    Set Suite Variable    ${WRONG_PORT_INT}
    Set Suite Variable    ${TCP_TIMEOUT}
    Set Suite Variable    ${USER}
    Set Suite Variable    ${PASS}



