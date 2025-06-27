*** Settings ***
Resource    ../resources/get_env.robot
Resource    ../resources/resource.robot


Test Setup      Open Connection To SMTP
Test Teardown   Close Connection

*** Test Cases ***

Test NOOP Command TC0025
    Load Environment Variables

    ${output}=    SSHLibrary.Execute Command    echo -e "EHLO example.com\nNOOP" | nc ${HOST} ${PORT_INT}
    Log    ${output}
    Should Contain    ${output}    250