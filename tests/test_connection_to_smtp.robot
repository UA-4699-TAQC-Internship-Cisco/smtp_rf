*** Settings ***
Resource    ../resources/get_env.robot
Resource    ../resources/resource.robot
Library     Telnet

Suite Setup     Load Environment Variables
Test Setup      Open Connection To SMTP
Test Teardown   Close Connection

*** Test Cases ***
Test SMTP Connection TC001

     ${response}=       Read Until    220
     Log ${response}
     Should Contain     ${response}    220