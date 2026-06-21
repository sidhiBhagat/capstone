*** Settings ***
Library     SeleniumLibrary
Resource    ../../variables/openNewAccount_locator.robot
Resource    ../../resources/keywords/common_resources.robot

*** Keywords ***
Capture Destination Account
    Wait Until Element Is Visible    ${NEW_ACCOUNT_ID_LABEL}    timeout=10s
    ${DEST_ACCOUNT}=    Get Text
    ...    ${NEW_ACCOUNT_ID_LABEL}

    Set Suite Variable
    ...    ${DEST_ACCOUNT}

    Log To Console    Destination Account: ${DEST_ACCOUNT}
Open New Account - Savings
    Wait Until Element Is Visible    ${open_new_account}    timeout=20s
    Click Element    ${open_new_account}
    Click Element    ${account_type}
    Click Element    ${account_type_dropdown}
    Sleep    2s
    Log To Console    Clicking the Open New Account button
    Click Element    ${submit_btn}
    Wait Until Page Contains    Congratulations    10s

Open New Account - Checking
    Wait Until Element Is Visible    ${open_new_account}    timeout=20s
    Click Element    ${open_new_account}
    Click Element    ${account_type}
    Click Element    ${account_type_dropdown2}
    Sleep    2s
    Log To Console    Clicking the Open New Account button
    Click Element    ${submit_btn}
    Wait Until Page Contains    Congratulations    10s

Verify Confirmation Message and Account Number
    Open New Account - Savings
    ${confirmation_message}=    Get Text    xpath=//div[@id="openAccountResult"]//p
    Log To Console    Confirmation Message: ${confirmation_message}
    ${account_number}=    Get Text    xpath=//div[@id="openAccountResult"]//p[2]
    Log To Console    Account Number: ${account_number}