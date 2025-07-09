*** Settings ***
Library    ../libraries/tcp_library.py
Resource    ../resources/get_env.robot


*** Test Cases ***
TC003: Successful Connection to TLS Port (465)
    Load Environment Variables

    ${HOST}=        Get Environment Variable    HOSTNAME
    ${TLS_PORT}=        Get Environment Variable    TLS_PORT
    ${tls_port_int}=    Evaluate    int(${TLS_PORT})

    ${tls_socket}=    Create Tls Socket    ${HOST}    ${tls_port_int}
    ${banner}=    Read Tls Banner    ${tls_socket}
    Should Start With    ${banner}    220
    Close Smtp Connection
