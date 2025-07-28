*** Settings ***
Resource    ../resources/tb_keywords.robot

Test Setup      Connect To SMTP And Authenticate

*** Variables ***
${users_mail}=     root


*** Test Cases ***
Validate User With VRFY Command (for root)
    ${answer}=     VRFY Command     ${users_mail}
    Should Contain      ${answer}      252 2.0.0 ${users_mail}

