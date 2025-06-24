*** Settings ***
Resource    get_env.robot
Library     Telnet

*** Keywords ***
Open Connection To SMTP
     Open Connection    ${HOST}    ${PORT_INT}


Close Connection With SMTP
    Close Connection
