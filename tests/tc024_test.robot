*** Settings ***
Resource    ../resources/tb_keywords.robot

Test Setup      Connect To SMTP And Authenticate


*** Test Cases ***
Send the EHLO example.com command
    ${ehlo_result}=    Send EHLO
    Should Contain    ${ehlo_result}    250
    Should Contain    ${ehlo_result}    PIPELINING