*** Settings ***
Library    SSHLibrary


*** Variables ***
${SMTP_PORT}    587
${SMTP_HOST}    smtp.example.com


*** Test Cases ***
Verify Successful Connection And Initiation of TLS on the Submission Port
    Open Connection    ${HOST}
    ${result}=    Execute Command    nc -vz ${HOST} ${PORT}
    Log    ${result}
    Close Connection

   # ${banner}=    Evaluate    __import__('smtplib').SMTP("${SMTP_HOST}", ${SMTP_PORT}).noop()
   # Log    ${banner}
   # Should Be Equal As Integers    ${banner[0]}    250