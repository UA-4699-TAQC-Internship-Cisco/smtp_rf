*** Settings ***
Library    Process
Library    SSHLibrary
Library    OperatingSystem
Resource    ../resources/get_env.robot
Resource    ../resources/tb_keywords.robot

Test Setup      Connect To SMTP And Authenticate


*** Variables ***
${FROM}     tetiana

*** Test Cases ***
Initiate a mail transaction (MAIL FROM, RCPT TO)
    ${mail_998_result}=    Send Line Of 998 Characters
    Should Contain    ${mail_998_result}    354
    ${mail_999_result}=    Send Line Of 999 Characters
    Should Contain    ${mail_999_result}    354
    #Should Contain Any    ${mail_999_result}    552    500    451

    Close Connection
