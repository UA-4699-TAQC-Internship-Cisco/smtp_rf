*** Settings ***
Resource    get_env.robot
Resource    ../resources/tb_keywords.robot
Resource    ../resources/resource.robot

Test Setup      Connect To SMTP And Authenticate

*** Variables ***
${from}=        ${SENDER}
${to}=          ${RECIPIENT}
${subject}=     Test
${body}=        Successful Email Delivery Logging Test


*** Test Cases ***
Successful Email Delivery Logging
    Send Mail    ${from}    ${to}    ${subject}   ${body}
    ${maillog}=        Read Logfile
    Should Contain      ${maillog}      FROM:<${SENDER}>
    Should Contain      ${maillog}      TO:<${RECIPIENT}>
