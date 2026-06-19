*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/pages/OpenNewAccount_page.robot

Suite Setup     Load Environment
Test Setup      Open Application
Test Teardown       Close Application
*** Test Cases ***
TC-AC-UI-01 open-New-Account
    Open New Account - Savings
    Capture Destination Account
TC-AC-UI-02 open-New-Account
    Open New Account - Checking
    Capture Destination Account
TC-AC-UI-03 Verify the confirmation message and account number
    Verify Confirmation Message and Account Number
