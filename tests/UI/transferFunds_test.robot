*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/pages/transferFunds_page.robot

Suite Setup     Load Environment
Test Setup      Open Application
Test Teardown       Close Application

*** Test Cases ***
TC-AC-UI-04 Transfer Funds Validation
    Transfer Funds
TC-AC-UI-05 Verify Transfer Confirmation
    Verify Transfer Confirmation
