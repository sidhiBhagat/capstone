*** Settings ***
Library     SeleniumLibrary
Resource    ../../variables/transferFunds_locator.robot
Resource    ../../resources/keywords/common_resources.robot

*** Keywords ***
Transfer Funds

    Wait Until Page Contains   Accounts Overview     25s
    Click Element    ${transfer_funds}

    Input Text
    ...    ${amount}
    ...    100

    Set Suite Variable
    ...    ${TRANSFER_AMOUNT}
    ...    100

    ${from_options}=    Get List Items    ${from_account}
    Log To Console    FROM OPTIONS=${from_options}
    Wait Until Element Is Visible
    ...    ${from_account}
    ...   3s

    Sleep    2s
    Select From List By Label
    ...    ${from_account}
    ...    ${SOURCE_ACCOUNT}
    Sleep    2s
    Select From List By Label
    ...    ${to_account}
    ...    ${DEST_ACCOUNT}

    Click Element
    ...    ${transfer_btn}

    Wait Until Page Contains
    ...    Transfer Complete!
Verify Transfer Confirmation
    Wait Until Page Contains   Accounts Overview     25s
    Click Element    ${transfer_funds}
    Click Element    ${amount}
    Input Text    ${amount}    100
    Click Element    ${from_account}
    Sleep    2s
    Click Element    ${from_account_dropdown}
    Click Element    ${to_account}
    Click Element    ${to_account_dropdown}
    Log To Console    Clicking the Transfer button
    Click Element    ${transfer_btn}
    Log To Console    Clicked the Transfer button
    Sleep  5s
    ${confirmation_message}=    Get Text    xpath=//div[@id="showResult"]//p
    Log To Console    Confirmation Message: ${confirmation_message}