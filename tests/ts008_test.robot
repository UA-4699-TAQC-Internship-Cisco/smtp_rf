*** Settings ***
Library    SSHLibrary
Library    OperatingSystem
Resource    ../resources/get_env.robot
Resource    ../resources/tb_keywords.robot


*** Variables ***
${AUTH_STRING}       AGludmFsaWRfdXNlcgB3cm9uZ19wYXNz


*** Test Cases ***
 Failed Authentication (Invalid Credentials)
    Connect To SMTP And Authenticate
#Send the EHLO example.com command
    ${ehlo_result}=   Send EHLO
    Should Contain      ${ehlo_result}    250
#Attempt AUTH PLAIN or AUTH LOGIN, provide incorrect (invalid) credentials
    ${auth_result}=    Provide Incorrect AUTH LOGIN
    Should Contain    ${auth_result}    503 5.5.1

    Close Connection





