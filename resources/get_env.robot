*** Settings ***
Library    OperatingSystem

*** Keywords ***
Load Environment Variables
    ${HOST}=    Get Environment Variable    HOSTNAME
    ${PORT}=    Get Environment Variable    SMTP_PORT
    ${PORT_INT}=    Evaluate    int(${PORT})
    ${USER}=    Get Environment Variable    SSH_USERNAME
    ${PASS}=    Get Environment Variable    PASSWORD

    Log    Loaded host: ${HOST}
    Log    Port: ${PORT_INT}

    Set Suite Variable    ${HOST}
    Set Suite Variable    ${PORT_INT}
    Set Suite Variable    ${USER}
    Set Suite Variable    ${PASS}


