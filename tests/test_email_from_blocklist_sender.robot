*** Settings ***
Resource    resources/get_env.robot
Resource    resources/resource.robot

Test Setup      Open Connection To SMTP
Test Teardown   Close Connection


*** Test Cases ***
Email from Blacklisted Sender TC0029
    Load Environment Variables

    ${commands}=    Catenate    SEPARATOR=\n
    ...    MAIL FROM:<spam@example.net>
    ...    RCPT TO:<user1@localhost>
    ...    QUIT

    ${output}=    SSHLibrary.Execute Command    echo -e "${commands}" \| nc ${HOST} ${PORT_INT}
    Log    ${output}

    Should Contain    ${output}    554 5.7.1