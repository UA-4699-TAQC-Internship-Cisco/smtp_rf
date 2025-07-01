*** Settings ***
Library    SSHLibrary
Library    OperatingSystem
Resource    resources/get_env.robot


*** Variables ***
${AUTH_STRING}       AGludmFsaWRfdXNlcgB3cm9uZ19wYXNz


*** Test Cases ***

Establish a connection to the SMTP server
    Load Environment Variables
    Open Connection    ${HOST}
    Login              ${USER}    ${PASS}
Send the EHLO example.com command
    ${cmd}=    Set Variable    echo -e "EHLO example.com\r\n" | openssl s_client -starttls smtp -connect ${HOST}:${PORT_INT}
    ${rc}    ${ehlo_result}=    Run And Return Rc And Output    ${cmd}
    Should Contain    ${ehlo_result}    250
Attempt AUTH PLAIN or AUTH LOGIN, provide incorrect (invalid) credentials
    ${inv_data_cmd}=    Set Variable    echo -e "AUTH LOGIN ${AUTH_STRING}\r\n" | nc ${HOST} ${PORT_INT}
    ${auth_result}=    Execute Command    ${inv_data_cmd}
    Should Contain    ${auth_result}    503 5.5.1

    Close Connection





