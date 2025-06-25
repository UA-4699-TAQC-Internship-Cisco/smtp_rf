*** Settings ***
Resource    ../resources/get_env.robot
Resource    ../resources/resource.robot

Test Setup      Open Connection To SMTP
Test Teardown   Close Connection


*** Variables ***
${FROM}       root@localhost
${TO}         user1@localhost
${SUBJECT}    Send email test
${BODY}       Send basic email test


*** Test Cases ***
Test Send Basic Mail TC011
    Load Environment Variables

     ${result}=    Send Mail    ${HOST}    ${PORT_INT}    ${FROM}    ${TO}    ${BODY}    ${SUBJECT}
    Should Be Equal As Strings    ${result}    {} import smtplib