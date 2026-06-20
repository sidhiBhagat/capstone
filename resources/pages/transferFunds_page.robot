*** Settings ***
Library     SeleniumLibrary
Resource    ../../variables/transferFunds_locator.robot
Resource    ../../resources/keywords/common_resources.robot
#*** Variables ***
#${DEST_ACCOUNT}    xpath= //select[@id="toAccountId"]/option[1]

*** Keywords ***
Transfer Funds
    Wait Until Page Contains    Accounts Overview    25s
    Click Element    ${transfer_funds}
    ${title}=    Get Title
    Log To Console    PAGE TITLE=${title}

    ${body}=    Get Text    xpath=//body
    Log To Console    ${body}
    Input Text    ${amount}    100
    Set Suite Variable    ${TRANSFER_AMOUNT}    100

    Wait Until Element Is Visible    ${from_account}    10s
#    Wait Until Keyword Succeeds    10x    1s
#    ...    Page Should Contain Element    ${from_account}/options
    Sleep    3s
    ${from_options}=    Get List Items    ${from_account}
    Log To Console    FROM OPTIONS=${from_options}

    ${source}=    Set Variable    ${from_options}[0]
#    ${dest}=      Set Variable    ${DEST_ACCOUNT}
    ${captured_dest}=    Get Variable Value    ${DEST_ACCOUNT}    ${None}

#    Set Suite Variable    ${SOURCE_ACCOUNT}    ${source}
#    Set Suite Variable    ${DEST_ACCOUNT}      ${dest}

    IF    $captured_dest is not None
        ${dest}=    Set Variable    ${captured_dest}
    ELSE
        ${dest}=    Set Variable    ${from_options}[1]
    END

    Select From List By Label    ${from_account}    ${source}
    Select From List By Label    ${to_account}      ${dest}

    Log To Console    ${dest}
    Click Element    ${transfer_btn}
    Wait Until Page Contains    Transfer Complete!

#Verify Transfer Confirmation
#    Transfer Funds
#    ${confirmation_message}=    Get Text    xpath=//div[@id="showResult"]//p
#    Log To Console    Confirmation Message: ${confirmation_message}