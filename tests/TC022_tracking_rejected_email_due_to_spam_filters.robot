*** Settings ***
Library           ../libraries/smtp_library.py
Resource          ../resources/get_env.robot
Library           OperatingSystem

*** Variables ***
${SPAM_WORDS}     lottery\free money\spam
${LOG_FILE}       /var/log/maillog

*** Test Cases ***
TC022 Tracking Rejected Email Due To Spam Filters  
    Load Environment Variables
    ${HOSTNAME}            Get Environment Variable    HOSTNAME
    ${SMTP_PORT}           Get Environment Variable    SMTP_PORT
    ${EHLO_DOMAIN}         Get Environment Variable    EHLO_DOMAIN
    ${REMOTE_RECIPIENT}    Get Environment Variable    REMOTE_RECIPIENT
    ${LOCAL_SENDER}        Get Environment Variable    LOCAL_SENDER
    
    Open Smtp Connection    ${HOSTNAME}    ${SMTP_PORT}
    ${subject}=    Set Variable    Suspicious offer
    ${body}=    Catenate    SEPARATOR=\n
    ...    Hello,
    ...    You have won the lottery!
    ...    Claim your free money now!
    ...    This is not test_spam_test, we promise.
    
    Send Email With Body    ${LOCAL_SENDER}    ${REMOTE_RECIPIENT}    ${subject}    ${body}
    Sleep    2s    # Allow time for server to process and log
    ${log_content}=    Get File    ${LOG_FILE}
    Should Contain Any    ${log_content}
    ...    blocked
    ...    reject
    ...    spam
    ...    spamd
    ...    content rejected
    Close Smtp Connection

*** Keywords ***
Send Email With Body
    [Arguments]    ${from_addr}    ${to_addr}    ${subject}    ${body}
    Send SMTP Command    EHLO test.com
    Send SMTP Command    MAIL FROM:<${from_addr}>
    Send SMTP Command    RCPT TO:<${to_addr}>
    Send SMTP Command    DATA
    Send SMTP Command    From: ${from_addr}
    Send SMTP Command    To: ${to_addr}
    Send SMTP Command    Subject: ${subject}
    Send SMTP Command    ""
    :FOR    ${line}    IN    @{body.splitlines()}
    \    Send SMTP Command    ${line}
    Send SMTP Command    .
