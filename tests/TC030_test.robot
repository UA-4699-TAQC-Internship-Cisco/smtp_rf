*** Settings ***
Library    SSHLibrary
Library    OperatingSystem
Resource    ../resources/get_env.robot


*** Variables ***
${FROM}     tetiana

*** Test Cases ***
Connect and authenticate
    Load Environment Variables
    Open Connection    ${HOST}
    Login              ${USER}    ${PASS}
Initiate a mail transaction (MAIL FROM, RCPT TO)
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n MAIL FROM:<${FROM}>\r\nRCPT TO:<${USER}>\r\nDATA:<${SUBJECT}>\r\nQUIT\r\n" " | nc ${HOST} ${PORT_INT}
    ${mail_result}=    Execute Command    ${cmd}
