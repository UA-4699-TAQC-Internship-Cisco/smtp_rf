*** Settings ***
Library    SSHLibrary
Library    OperatingSystem
Resource    ../resources/get_env.robot
Resource    ../resources/tb_keywords.robot


*** Variables ***
${SMTP_PORT}       587


*** Test Cases ***
Successful Connection to Submission Port (587) with STARTTLS
    Load Environment Variables
    Connect To SMTP And Authenticate
    ${connection_result}=    Test TCP connectivity
    Should Contain    ${connection_result}    Connected to ${HOST}:${SMTP_PORT}
#EHLO
    ${ehlo_result}=   Send EHLO     ${SMTP_PORT}
    Should Contain      ${ehlo_result}    250

#Send the STARTTLS
    ${cmd_starttls}=    Set Variable    openssl s_client -starttls smtp -connect ${HOST}:${HOST} -verify_return_error
    ${rc}    ${startts_result}=   Run And Return Rc And Output    ${cmd_starttls}
    Should Contain    Return Code: ${rc}    Verify return code
    Should Not Contain    ${startts_result}    Connection refused
    Should Be Equal As Integers    ${rc}    0

    Close Connection
