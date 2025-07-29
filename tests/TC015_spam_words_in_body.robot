*** Settings ***
Resource    ../resources/get_env.robot
Resource    ../resources/tb_keywords.robot
Resource    ../resources/resource.robot

Test Setup      Connect To SMTP And Authenticate

*** Variables ***
${subject}=     Congratulations!
${body}=        Congratulations, you won the lottery!


*** Test Cases ***
Successful Email Delivery Logging
    Send Mail    ${SENDER}    ${RECIPIENT}    ${subject}   ${body}
    ${maillog}=        Read Logfile
    Close Smtp Connection
