*** Settings ***
Library     Collections
Library     RequestsLibrary
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/pages/OpenNewAccount_page.robot
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../resources/pages/transferFunds_page.robot

Suite Setup   Initialize API Suite

*** Variables ***
${TRANSFER_AMOUNT}    100.00

*** Test Cases ***
#Capture Source Balance Before Transfer
#    ${response}=    Get Account Details    ${SOURCE_ACCOUNT}
#    ${account}=    Evaluate    $response.json()
#    Set Suite Variable    ${SRC_BALANCE_BEFORE}    ${account}[balance]
#
#Capture Destination Balance Before Transfer
#    ${response}=    Get Account Details    ${DEST_ACCOUNT}
#    ${account}=    Evaluate    $response.json()
#    Set Suite Variable    ${DEST_BALANCE_BEFORE}    ${account}[balance]

TC-API-GET-01 Verify Accounts API Returns 200
    ${response}=    Get Customer Accounts    ${CUSTOMER_ID}
    Should Be Equal As Integers    ${response.status_code}    200
    Log To Console    ${response.status_code}

TC-API-GET-02 Verify Accounts Response Fields

    ${response}=    Get Customer Accounts
    ...    ${CUSTOMER_ID}
    Log To Console    Response: ${response.text}

    Should Be Equal As Integers    ${response.status_code}    200

    ${accounts}=    Evaluate    $response.json()

    ${account}=    Set Variable    ${accounts}[0]

    Log To Console    Account ID: ${account}[id]
    Log To Console    Customer ID: ${account}[customerId]
    Log To Console    Account Type: ${account}[type]
    Log To Console    Balance: ${account}[balance]

    Dictionary Should Contain Key    ${account}    id
    Dictionary Should Contain Key    ${account}    customerId
    Dictionary Should Contain Key    ${account}    type
    Dictionary Should Contain Key    ${account}    balance

    Should Be Equal As Integers    ${account}[customerId]    ${CUSTOMER_ID}
