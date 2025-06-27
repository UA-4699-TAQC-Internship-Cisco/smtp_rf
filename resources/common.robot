*** Settings ***
Library    OperatingSystem
Library     ../../libraries/isssaq_smtp.py

*** Keywords ***
Connect Smtp Server
    [Arguments]    ${HOST}    ${SMTP_PORT}=25
    ${SMTP_SRV}=    Connect Server    ${HOST}    ${SMTP_PORT}
    [Return]    ${SMTP_SRV}

Log In To Server
    [Arguments]    ${USER}    ${password}    ${SMTP_SRV}
    @{AUTH_RESPONSE}=    Login Server    ${USER}    ${password}    ${SMTP_SRV}
    [Return]    ${AUTH_RESPONSE}[0]

Check Hostname
    [Arguments]    ${HOSTNAME}    ${SMTP_SRV}
    @{response}=    Validate Hostname    ${HOSTNAME}    ${SMTP_SRV}
    Should Be Equal    ${response}[0]    ${250}

Send Message Via Host
    [Arguments]    ${HOST}    ${FROM_ADDR}    ${TO_ADDR}    ${MESSAGE}
    ${SMTP_SRV}=    Connect Server    ${HOST}
    Send Message Smtp    ${FROM_ADDR}    ${TO_ADDR}    ${MESSAGE}    ${SMTP_SRV}

Open Recent Mail
    [Arguments]    ${HOST}    ${username}    ${password}
    ${RECEIVED_MAIL}    Read Recent Mail    ${username}    ${password}    ${HOST}
    [Return]    ${RECEIVED_MAIL}
    
Send Quit Command
    [Arguments]    ${SMTP_SRV}
    @{RESPONSE_MSG}=    Make Quit    ${SMTP_SRV}
    [Return]    @{RESPONSE_MSG}