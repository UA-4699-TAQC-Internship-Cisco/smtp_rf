*** Settings ***
Resource    resources/get_env.robot
Resource    resources/common.robot
Library    String

*** Variables ***
${message}=    To wiadomość z prośbą o sprawdzenie poprawności tłumaczenia.
${SUBJECT}=    Test message

*** Test Cases ***
Send Mail With Utf8
    Load Environment Variables
    ${encoded_message}    Encode String To Bytes    ${message}    UTF-8
    ${LETTER_UTF8}=    Form A Letter For Sending    ${encoded_message}    ${SENDER}    ${RECIPIENT}    ${SUBJECT}
    Send Message Via Host    ${HOST}    ${SENDER}    ${RECIPIENT}    ${LETTER_UTF8}
    ${SENT_LETTER}=    Open Recent Mail    ${HOST}    ${USER}    ${PASS}
    Should Contain    ${SENT_LETTER}    ${encoded_message}
