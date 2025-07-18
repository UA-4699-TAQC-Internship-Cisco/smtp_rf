*** Settings ***
Library    ../libraries/tcp_library.py
Resource    ../resources/get_env.robot


*** Test Cases ***
TC003: Successful Connection to TLS Port (465)
    Load Environment Variables

    ${HOST}=        Get Environment Variable    HOSTNAME
    ${TLS_PORT}=    Get Environment Variable    TLS_PORT
    ${TLS_PORT_INT}=    Evaluate    int(${TLS_PORT})
    
    Log    Attempting TLS connection to ${HOST}:${TLS_PORT_INT}...
    
    ${tls_socket}=    Create Tls Socket    ${HOST}    ${TLS_PORT_INT}
    ${banner}=    Read Tls Banner    ${tls_socket}
    Log    Received banner: ${banner}
    
    Should Start With    ${banner}    220    Expected SMTP banner starting with 220
    
    Close Tls Socket    ${tls_socket}
    Log    TLS connection test completed successfully
