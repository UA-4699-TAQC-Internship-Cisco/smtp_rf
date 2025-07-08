*** Settings ***
Library    ../libraries/marta_smtp_socket.py
Resource    ../resources/marta_get_env.robot


*** Test Cases ***
TC003: Successful Connection to TLS Port (465)
    Load Environment Variables    .env

    ${tls_host}=        Get Environment Variable    TLS_HOST
    ${tls_port}=        Get Environment Variable    TLS_PORT
    ${tls_port_int}=    Evaluate    int(${tls_port})

    ${tls_socket}=    Create Tls Socket    ${tls_host}    ${tls_port_int}
    ${banner}=    Read Tls Banner    ${tls_socket}
    Should Start With    ${banner}    220
    Close Smtp Connection
