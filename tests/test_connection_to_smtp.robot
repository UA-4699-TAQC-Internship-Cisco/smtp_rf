*** Settings ***
Resource    ../resources/get_env.robot
Resource    ../resources/resource.robot


Test Setup      Open Connection To SMTP
Test Teardown   Close Connection

*** Test Cases ***


Test SMTP Connection TC001
    Load Environment Variables

    ${output}=    SSHLibrary.Execute Command    echo | nc ${HOST} ${PORT_INT}
    Log    ${output}
    Should Contain    ${output}    220

