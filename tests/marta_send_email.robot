*** Settings ***
Resource    ../resources/marta_get_env.robot
Suite Setup    Load Environment Variables
Library    Process

*** Variables ***
${SMTP_SCRIPT_PATH}      ../libraries/marta_send_get_email.py
${SMTP_EXPECTED_OUTPUT}  Email sent successfully!

*** Test Cases ***
Test SMTP Email Sending
    ${env}=    Create Dictionary
    Log    Host: ${HOST}
    Log    Port: ${PORT_INT}
    Log    From: ${FROM_ADDR}
    Log    To: ${TO_ADDR}
    ${result}=    Run Process    python    ${SMTP_SCRIPT_PATH}
    ...    env=${env}
    ...    timeout=30s

Print Host From Env
    Get Environment Variables
    Log    SMTP Server: ${HOST}
