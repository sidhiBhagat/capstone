*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../resources/keywords/api_keywords.robot

Suite Setup     Run Keywords    Load Environment    AND    Create API Session
Test Setup      Open Application
Test Teardown       Close Application

*** Test Cases ***
TC-E2E-01 Create Account and Verify via API
    [Documentation]    This test case creates a new account through the UI and verifies its existence via the API.
    Open New Account - Savings
    Capture Destination Account
    Get Customer ID From Account    ${DEST_ACCOUNT}

#    Log To Console    Customer ID: ${CUSTOMER_ID}

    ${response}=    GET On Session
    ...    parabank
    ...    /parabank/services/bank/customers/${CUSTOMER_ID}/accounts
    ...    expected_status=200

    Log To Console    Status Code: ${response.status_code}

    Log To Console    Response Body: ${response.text}

    Should Contain    ${response.text}    ${DEST_ACCOUNT}

TC-E2E-02 Create Account and Validate Type and Balance via API
    [Documentation]    This test case creates a new account through the UI and validates its type and balance via the API.
    Open New Account - Checking
    Capture Destination Account
    Get Customer ID From Account    ${DEST_ACCOUNT}

    ${response}=    Get Account Details    ${DEST_ACCOUNT}

    Should Be Equal As Integers
    ...    ${response.status_code}
    ...    200
#
#    Log To Console    Status Code: ${response.status_code}
    Get Account Details    ${DEST_ACCOUNT}

    ${body}=    Set Variable    ${response.json()}

    Log To Console    Account Type: ${body}[type]
    Log To Console    Account Balance: ${body}[balance]

    Should Be Equal
    ...    ${body}[type]
    ...    CHECKING

    Should Be Equal As Numbers
    ...    ${body}[balance]
    ...    100.00