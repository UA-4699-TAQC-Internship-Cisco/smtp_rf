*** Settings ***
Resource    resources/get_env.robot
Resource    resources/resource.robot

Test Setup      Open Connection To SMTP
Test Teardown   Close Connection


*** Variables ***
${FROM}       root@localhost
${TO}         user1@localhost
${SUBJECT}    Test without to/from1
${BODY}       Test without to/from1



*** Test Cases ***
Test Send Basic Mail TC011
    Load Environment Variables

    ${output}=    Send Mail
    ...           ${FROM}
    ...           ${TO}
    ...           ${SUBJECT}
    ...           ${BODY}


    Should Contain    ${output}    250
    Should Contain    ${output}    354


