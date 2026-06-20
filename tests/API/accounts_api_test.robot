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
Capture Source Balance Before Transfer
    ${response}=    Get Account Details    ${SOURCE_ACCOUNT}
    ${account}=    Evaluate    $response.json()
    Set Suite Variable    ${SRC_BALANCE_BEFORE}    ${account}[balance]

Capture Destination Balance Before Transfer
    ${response}=    Get Account Details    ${DEST_ACCOUNT}
    ${account}=    Evaluate    $response.json()
    Set Suite Variable    ${DEST_BALANCE_BEFORE}    ${account}[balance]

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

TC-API-BAL-03 Record Balances Before Transfer
    ${src_response}=    Get Account Details    ${SOURCE_ACCOUNT}
    ${dest_response}=   Get Account Details    ${DEST_ACCOUNT}

    ${src_account}=     Set Variable    ${src_response.json()}
    ${dest_account}=    Set Variable    ${dest_response.json()}

    ${src_balance_before}=    Set Variable
    ...    ${src_account}[balance]

    ${dest_balance_before}=   Set Variable
    ...    ${dest_account}[balance]

    Set Suite Variable
    ...    ${SRC_BALANCE_BEFORE}
    ...    ${src_balance_before}

    Set Suite Variable
    ...    ${DEST_BALANCE_BEFORE}
    ...    ${dest_balance_before}

    Log To Console  Source Balance Before: ${SRC_BALANCE_BEFORE}
    Log To Console  Destination Balance Before: ${DEST_BALANCE_BEFORE}
    Transfer Funds

#TC-API-BAL-04 Verify Source Account Debited After Transfer
#
#    ${response}=    Get Account Details    ${SOURCE_ACCOUNT}
#
#    ${account}=    Evaluate    $response.json()
#
#    ${SRC_BALANCE_AFTER}=    Set Variable
#    ...    ${account}[balance]
#    Log To Console    Before=${SRC_BALANCE_BEFORE}
#    Log To Console    Transfer=${TRANSFER_AMOUNT}
#    Log To Console    After=${SRC_BALANCE_AFTER}
#    Log To Console    SourceAccount=${SOURCE_ACCOUNT}
#
#    Log To Console    Source Balance After: ${SRC_BALANCE_AFTER}
#
#    ${EXPECTED_BALANCE}=    Evaluate    ${SRC_BALANCE_BEFORE} - ${TRANSFER_AMOUNT}
#
#    Log To Console    Expected Balance: ${EXPECTED_BALANCE}
#
#    Should Be Equal As Numbers    ${SRC_BALANCE_AFTER}    ${EXPECTED_BALANCE}   precision=2
#
#TC-API-BAL-05 Verify Destination Account Credited After Transfer
#
#    ${response}=    Get Account Details    ${DEST_ACCOUNT}
#
#    ${account}=    Set Variable    ${response.json()}
#
#    ${DEST_BALANCE_AFTER}=    Set Variable
#    ...    ${account}[balance]
#
#    Log To Console    Destination Balance Before: ${DEST_BALANCE_BEFORE}
#
#    Log To Console    Transfer Amount: ${TRANSFER_AMOUNT}
#
#    Log To Console    Destination Balance After: ${DEST_BALANCE_AFTER}
#
#    ${EXPECTED_BALANCE}=    Evaluate
#    ...    ${DEST_BALANCE_BEFORE} + ${TRANSFER_AMOUNT}
#
#    Log To Console    Expected Balance: ${EXPECTED_BALANCE}
#
#    Should Be Equal As Numbers
#    ...    ${DEST_BALANCE_AFTER}
#    ...    ${EXPECTED_BALANCE}
TC-API-BAL-04 Verify Source Account Debited After Transfer
    ${response}=    Get Account Details    ${SOURCE_ACCOUNT}
    ${account}=    Evaluate    $response.json()
    ${SRC_BALANCE_AFTER}=    Set Variable    ${account}[balance]

    Log To Console    Before=${SRC_BALANCE_BEFORE}
    Log To Console    Transfer=${TRANSFER_AMOUNT}
    Log To Console    After=${SRC_BALANCE_AFTER}
    Log To Console    SourceAccount=${SOURCE_ACCOUNT}

    ${EXPECTED_BALANCE}=    Evaluate    ${SRC_BALANCE_BEFORE} - ${TRANSFER_AMOUNT}
    Log To Console    Expected Balance: ${EXPECTED_BALANCE}

    Should Be Equal As Numbers    ${SRC_BALANCE_AFTER}    ${EXPECTED_BALANCE}    precision=2

TC-API-BAL-05 Verify Destination Account Credited After Transfer
    ${response}=    Get Account Details    ${DEST_ACCOUNT}
    ${account}=    Evaluate    $response.json()
    ${DEST_BALANCE_AFTER}=    Set Variable    ${account}[balance]

    Log To Console    Destination Balance Before: ${DEST_BALANCE_BEFORE}
    Log To Console    Transfer Amount: ${TRANSFER_AMOUNT}
    Log To Console    Destination Balance After: ${DEST_BALANCE_AFTER}

    ${EXPECTED_BALANCE}=    Evaluate    ${DEST_BALANCE_BEFORE} + ${TRANSFER_AMOUNT}
    Log To Console    Expected Balance: ${EXPECTED_BALANCE}

    Should Be Equal As Numbers    ${DEST_BALANCE_AFTER}    ${EXPECTED_BALANCE}    precision=2