*** Settings ***
Resource    resources/get_env.robot
Resource    resources/resource.robot

Test Setup      Open Connection To SMTP
Test Teardown   Close Connection


*** Variables ***
${FROM}       root@localhost
${TO}         user1@localhost
${SUBJECT}    Send email with rset command
${BODY}       test with rset



*** Test Cases ***
RSET Command (Reset Session) TC0026
    Load Environment Variables

    ${commands}=    Catenate    SEPARATOR=\n
    ...    MAIL FROM:<${FROM}>
    ...    RCPT TO:<${TO}>
    ...    RSET
    ...    DATA
    ...    Subject: ${SUBJECT}
    ...    From: ${FROM}
    ...    To: ${TO}
    ...
    ...    ${BODY}
    ...    .
    ...    QUIT

    ${output}=    SSHLibrary.Execute Command    echo -e "${commands}" \| nc ${HOST} ${PORT_INT}
    Log    ${output}

    Should Contain    ${output}    503 5.5.1
