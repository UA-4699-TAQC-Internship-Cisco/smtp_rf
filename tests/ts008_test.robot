*** Settings ***
Library    SSHLibrary
Library    OperatingSystem
Resource    ../resources/get_env.robot


*** Variables ***
${AUTH_STRING}       AUTH PLAIN AGludmFsaWRfdXNlcgB3cm9uZ19wYXNz


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
    ${inv_data_cmd}=    Set Variable
    ...    bash -c "(echo -e 'EHLO test.com\r'; sleep 1; echo -e '${AUTH_STRING}\r'; sleep 1; echo -e 'QUIT\r') | openssl s_client -starttls smtp -connect ${HOST}:${PORT_INT} -crlf"
    ${rc}    ${ehlo_result}=    Run And Return Rc And Output    ${inv_data_cmd}
    Should Contain    ${ehlo_result}    535 5.7.8

    Close Connection





