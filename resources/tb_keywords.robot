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

Test TCP connectivity
    Load Environment Variables
    ${connection_result}=    Execute Command    nc -vz ${HOST} ${SMTP_PORT} 2>&1
    [Return]    ${connection_result}

Send Line Of 998 Characters
    Load Environment Variables
    ${line_998}=    Evaluate    "A" * 998
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n MAIL FROM:<${SENDER}>\r\nRCPT TO:<${USER}>\r\nDATA\r\n${line_998}\r\n.\r\nQUIT\r\n" | nc ${HOST} ${PORT_INT}
    ${mail_result}=    Execute Command    ${cmd}
    [Return]    ${mail_result}

Send Line Of 999 Characters
    Load Environment Variables
    ${line_999}=    Evaluate    "A" * 999
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n MAIL FROM:<${SENDER}>\r\nRCPT TO:<${USER}>\r\nDATA\r\n${line_999}\r\n.\r\nQUIT\r\n" | nc ${HOST} ${PORT_INT}
    ${mail_result}=    Execute Command    ${cmd}
    [Return]    ${mail_result}

Send EHLO
    [Arguments]     ${PORT}
    ${cmd}=    Set Variable    echo -e "EHLO ${HOST}\r\n" | nc ${HOST} ${PORT}
    ${ehlo_result}=    Execute Command    ${cmd}
    [Return]    ${ehlo_result}

Provide Incorrect AUTH LOGIN
    Load Environment Variables
    ${inv_data_cmd}=    Set Variable    echo -e "AUTH LOGIN ${AUTH_STRING}\r\n" | nc ${HOST} ${PORT_INT}
    ${auth_result}=    Execute Command    ${inv_data_cmd}
    [Return]    ${auth_result}

Read Logfile
     ${maillog}=        Execute Command     echo '${PASS}' | su -c 'cat /var/log/maillog'
     [Return]    ${maillog}

VRFY Command
    [Arguments]     ${USER}
    ${vrfy_cmd}=    Set Variable    echo -e "VRFY ${USER}\r\n" | nc ${HOST} ${PORT_INT}
    ${vrfy_result}=    Execute Command    ${vrfy_cmd}
    [Return]    ${vrfy_result}
