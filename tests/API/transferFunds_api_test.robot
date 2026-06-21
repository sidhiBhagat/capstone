*** Settings ***
Library     Collections
Library     RequestsLibrary
Resource    ../../resources/keywords/api_keywords.robot
#Resource    ../../resources/pages/OpenNewAccount_page.robot
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../resources/pages/transferFunds_page.robot

Suite Setup   Initialize API Suite
Test Teardown   Close Application

*** Variables ***
${TRANSFER_AMOUNT}    100.00

*** Keywords ***
Capture Source Balance Before Transfer
    ${response}=    Get Account Details    ${SOURCE_ACCOUNT}
    ${account}=    Evaluate    $response.json()
    Set Suite Variable    ${SRC_BALANCE_BEFORE}    ${account}[balance]

Capture Destination Balance Before Transfer
    ${response}=    Get Account Details    ${DEST_ACCOUNT}
    ${account}=    Evaluate    $response.json()
    Set Suite Variable    ${DEST_BALANCE_BEFORE}    ${account}[balance]
*** Test Cases ***
TC-API-BAL-03 Record Balances Before Transfer
    Capture Source Balance Before Transfer
    Capture Destination Balance Before Transfer

    Log To Console  Source Balance Before: ${SRC_BALANCE_BEFORE}
    Log To Console  Destination Balance Before: ${DEST_BALANCE_BEFORE}
    Log To Console    BEFORE DEST ACCOUNT=${DEST_ACCOUNT}
    Log To Console    BEFORE DEST BALANCE=${DEST_BALANCE_BEFORE}
    Log To Console    BEFORE TRANSFER DEST_ACCOUNT=${DEST_ACCOUNT}
    Transfer Funds
    Log To Console    AFTER TRANSFER DEST_ACCOUNT=${DEST_ACCOUNT}
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
    Log To Console    AFTER DEST ACCOUNT=${DEST_ACCOUNT}
    Log To Console    AFTER DEST BALANCE=${DEST_BALANCE_AFTER}
    Log To Console    Destination Balance Before: ${DEST_BALANCE_BEFORE}
    Log To Console    Transfer Amount: ${TRANSFER_AMOUNT}
    Log To Console    Destination Balance After: ${DEST_BALANCE_AFTER}

    ${EXPECTED_BALANCE}=    Evaluate    ${DEST_BALANCE_BEFORE} + ${TRANSFER_AMOUNT}
    Log To Console    Expected Balance: ${EXPECTED_BALANCE}

    Should Be Equal As Numbers    ${DEST_BALANCE_AFTER}    ${EXPECTED_BALANCE}    precision=2