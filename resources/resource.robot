*** Settings ***
Resource    get_env.robot
Library     SSHLibrary

*** Keywords ***
Open Connection To SMTP
     Load Environment Variables
     Log    Connecting to: ${HOST}:${PORT_INT}
     Open Connection    ${HOST}    22
     Login    ${USER}    ${PASS}


Close Connection With SMTP
    Close Connection
