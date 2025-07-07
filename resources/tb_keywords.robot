*** Settings ***
Library    SSHLibrary
Library    Process
Library    OperatingSystem
Resource    ./get_env.robot


*** Keywords ***
Connect To SMTP And Authenticate
    Load Environment Variables
    Open Connection    ${HOST}
    Login              ${USER}    ${PASS}

Send Line Of 998 Characters
    ${line_998}=    Evaluate    "A" * 998
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n MAIL FROM:<${SENDER}>\r\nRCPT TO:<${USER}>\r\nDATA\r\n${line_998}\r\n.\r\nQUIT\r\n" | nc ${HOST} ${PORT_INT}
    ${mail_result}=    Execute Command    ${cmd}
    [Return]    ${mail_result}

Send Line Of 999 Characters
    ${line_999}=    Evaluate    "A" * 999
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n MAIL FROM:<${SENDER}>\r\nRCPT TO:<${USER}>\r\nDATA\r\n${line_999}\r\n.\r\nQUIT\r\n" | nc ${HOST} ${PORT_INT}
    ${mail_result}=    Execute Command    ${cmd}
    [Return]    ${mail_result}

Send EHLO
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n" | nc ${HOST} ${PORT_INT}
    ${ehlo_result}=    Execute Command    ${cmd}
    [Return]    ${ehlo_result}