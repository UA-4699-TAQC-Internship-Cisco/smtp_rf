*** Settings ***
Library    ../libraries/yulia_smtp_library.py

*** Keywords ***
Connect To Invalid Port Keyword
    [Arguments]    ${host}    ${port}    ${timeout_int}
    ${result}=    Connect To Invalid Port    ${host}    ${port}    ${timeout_int}
    [Return]    ${result}
