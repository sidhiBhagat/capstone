
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    SeleniumLibrary

*** Keywords ***

Create API Session

    ${headers}=    Create Dictionary
    ...    Accept=application/json

    Create Session
    ...    parabank
    ...    url=https://parabank.parasoft.com
    ...    headers=${headers}
    ...    verify=${False}

Get Customer ID From Account

    [Arguments]    ${account_id}

    ${response}=    Get Account Details
    ...    ${account_id}

    ${account}=    Evaluate
    ...    $response.json()

    ${customer_id}=    Set Variable
    ...    ${account}[customerId]

    Set Suite Variable
    ...    ${CUSTOMER_ID}
    ...    ${customer_id}

    Log To Console    Customer ID: ${customer_id}
    RETURN    ${customer_id}

Get Customer Accounts

    [Arguments]    ${customer_id}

    ${response}=    GET On Session
    ...    parabank
    ...    /parabank/services/bank/customers/${customer_id}/accounts

    RETURN    ${response}

Get Account Details

    [Arguments]    ${account_id}

    ${response}=    GET On Session
    ...    parabank
    ...    /parabank/services/bank/accounts/${account_id}

    RETURN    ${response}
