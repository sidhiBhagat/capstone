*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../variables/loginpage_locators.robot

*** Keywords ***
Login to Application
    Input Text    ${username}   john
    Input Text    ${password}   demo

    Click Element    ${login_button}
#    Wait Until Page Contains    Accounts Overview     10s
    Sleep  4s
#    ${SOURCE_ACCOUNT}=    Get Text
#    ...    ${source_account}
#
#    Set Suite Variable
#    ...    ${SOURCE_ACCOUNT}
#
#    Log To Console    Source Account: ${SOURCE_ACCOUNT}


