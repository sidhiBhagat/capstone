*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../resources/pages/loginPage.robot
Resource    ../../resources/keywords/api_keywords.robot
Suite Setup    Run Keywords    Load Environment    AND    Create API Session
Test Setup      Open Application
Test Teardown       Close Application
*** Test Cases ***
TS-001 Verify Login Page
    [Documentation]    Verify the login page is displayed correctly with all required elements
    Login to Application
    Capture Source Account
    Get Customer ID From Account    ${SOURCE_ACCOUNT}

    Log To Console    Customer ID: ${CUSTOMER_ID}

