*** Settings ***
Library    OperatingSystem
Library    ../libraries/yulia_smtp_library.py
Resource   ../resources/yulia_smtp_keywords.robot

*** Test Cases ***
Connection To Invalid Port
    ${server_ip}=    Get Environment Variable    SERVER_IP
    ${wrong_port}=    Get Environment Variable    WRONG_PORT
    ${tcp_timeout}=    Get Environment Variable    TCP_TIMEOUT
    ${timeout}=    Run Keyword If    '${tcp_timeout}' == ''    5    ELSE    Convert To Integer    ${tcp_timeout}

    ${result}=    Connect To Invalid Port Keyword    ${server_ip}    ${wrong_port}    ${timeout}
    Should Be Equal As Strings    ${result}    CONNECTION_FAILED
