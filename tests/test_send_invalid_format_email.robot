*** Settings ***
Resource    ../resources/get_env.robot
Resource    ../resources/resource.robot

Test Setup      Open Connection To SMTP
Test Teardown   Close Connection


*** Variables ***
${FROM}       test@@123
${TO}         user1@localhost
${SUBJECT}    Send email with invalid format
${BODY}       Have you received it?)



*** Test Cases ***
Test Send Basic Mail Invalid Format TC016
    Load Environment Variables

    ${output}=    Send Mail
    ...           EHLO example.com
    ...           ${FROM}
    ...           ${TO}
    ...           ${SUBJECT}
    ...           ${BODY}

    Should Contain    ${output}    501

    Should Not Contain    ${output}    250 2.1.0
    Should Not Contain    ${output}    250 2.1.5
    Should Not Contain    ${output}    354