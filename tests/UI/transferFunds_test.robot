*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/pages/transferFunds_page.robot

Suite Setup     Load Environment
Test Setup      Open and Login Application
Test Teardown       Close Application

*** Test Cases ***
TC-AC-UI-04 - TC-AC-UI-05 Transfer Funds Validation and Verify Transfer Confirmation
    Transfer Funds
    ${confirmation_message}=    Get Text
    ...    xpath=//div[@id="showResult"]//p

    Page Should Contain
    ...    ${confirmation_message}
    ...    Transfer Complete
