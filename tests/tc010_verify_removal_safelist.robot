*** Settings ***
Resource    resources/get_env.robot
Resource    resources/common.robot

*** Variables ***
${SPAM_SUBJECT}=    victory in lottery
${text}=    test email
${test_address}=    test2@trusted.com

*** Test Cases ***
TC:010 Verify Removal From Safelist Makes Address Subject to Spam Filters
    Load Environment Variables
    ${mail}=    Form Template Letter    ${text}    ${test_address}    ${RECIPIENT}    ${spam_subject}
    Append Address To Safe    ${HOST}    ${22}    ${USER}    ${PASS}    ${test_address}
    Confirm Changes And Reload Smtp    ${HOST}    ${22}    ${USER}    ${PASS}
    Send Message Via Host    ${HOST}    ${test_address}    ${RECIPIENT}    ${mail}
    ${accepted_log}=    Check Maillog    ${HOST}    ${USER}    ${PASS}
    Should Contain    ${accepted_log}    delivered to maildir
    Remove Whitelist Sender    ${HOST}    ${22}    ${USER}    ${PASS}    ${test_address}
    Confirm Changes And Reload Smtp    ${HOST}    ${22}    ${USER}    ${PASS}
    Send Message Via Host    ${HOST}    ${test_address}    ${RECIPIENT}    ${mail}
    ${rejected_log}=    Check Maillog    ${HOST}    ${USER}    ${PASS}
    Should Contain    ${rejected_log}    message content rejected