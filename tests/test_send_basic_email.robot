*** Settings ***
Resource    ../resources/get_env.robot
Library    ../libraries/send_message_to_user.py


*** Variables ***
${FROM}       root@localhost
${TO}         user1@localhost
${SUBJECT}    Send email test
${BODY}       Send basic email test


*** Test Cases ***
Test Send Basic Mail TC0011
    Load Environment Variables

    ${result}=    Send Mail    ${HOST}    ${PORT_INT}    ${FROM}    ${TO}    ${BODY}    ${SUBJECT}
    Should Be Equal As Strings    ${result}    {}
