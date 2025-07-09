*** Settings ***
Library    Telnet
Library    String
Library    OperatingSystem

*** Keywords ***
Open SMTP Connection
    [Arguments]    ${host}    ${port}
    Open Connection    ${host}    ${port}
    ${greeting}=    Read Until    \n
    Log    Server greeting: ${greeting}

Close SMTP Connection
    Run Keyword And Ignore Error    Write    QUIT
    Close Connection

SMTP Command Should Succeed
    [Arguments]    ${command}
    Write    ${command}
    ${response}=    Read Until    \n
    Log    Command: ${command} -> Response: ${response}
    Should Not Contain    ${response}    5XX    Command failed with 5XX error

Encode String To Base64
    [Arguments]    ${input_string}
    ${temp_file}=    Set Variable    ${TEMPDIR}/temp_base64.txt
    Create File     ${temp_file}     ${input_string}
    ${base64}=    Run    base64 ${temp_file} | tr -d '\n'
    Remove File    ${temp_file}
    [Return]    ${base64}

Perform AUTH LOGIN
    [Arguments]    ${username}    ${password}
    ${base64_username}=    Encode String To Base64    ${username}
    ${base64_password}=    Encode String To Base64    ${password}

    SMTP Command Should Succeed    ${base64_username}
    SMTP Command Should Succeed    ${base64_password}
    ${response}=    Read Until    235
    Should Contain    ${response}    235 Authentication successful

Setup Environment And Open Connection
    [Arguments]    ${host}    ${port_int}
    Get Environment Variables
    Open Connection    ${host}    ${port_int}
