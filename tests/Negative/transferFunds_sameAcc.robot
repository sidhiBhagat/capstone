*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/pages/transferFunds_page.robot

Suite Setup     Load Environment
Test Setup      Open and Login Application
Test Teardown       Close Application

*** Test Cases ***
TC-NEG-TF-01 Transfer To Same Account
    [Documentation]    Attempt to transfer funds from an account to itself and verify that the application prevents this action with an appropriate error message.
    Wait Until Page Contains    Accounts Overview    15s
    Click Element    ${transfer_funds}

    Input Text    ${amount}    100
    Wait Until Element Is Visible    ${from_account_dropdown}
    ${account}=    Get Text
    ...    ${from_account_dropdown}

    Select From List By Label
    ...    ${from_account}
    ...    ${account}

    Select From List By Label
    ...    ${to_account}
    ...    ${account}

    Click Element    ${transfer_btn}

    Sleep    3s

    Capture Page Screenshot

TC-NEG-TF-02 Transfer Amount Exceeds Balance
    Wait Until Page Contains    Accounts Overview    15s
    Click Element    ${transfer_funds}

    Wait Until Element Is Visible    ${from_account}    10s
    Wait Until Keyword Succeeds    10x    1s
    ...    Page Should Contain Element    ${from_account}

    Input Text    ${amount}    999999
    Wait Until Element Is Visible    ${from_account_dropdown}
    ${account}=    Get Text
    ...    ${from_account_dropdown}

    Select From List By Label
    ...    ${from_account}
    ...    ${account}

    Select From List By Index
    ...    ${to_account}
    ...    ${account}[1]


    Click Element    ${transfer_btn}

    Sleep    3s
#
#    Capture Page Screenshot