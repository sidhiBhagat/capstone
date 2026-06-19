*** Settings ***
Library  SeleniumLibrary
Library  DateTime
#Library  Browser
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/pages/loginPage.robot
Resource    ../pages/OpenNewAccount_page.robot
Library      ../../config/env_loader.py

*** Variables ***
${BROWSER}   chrome
${ENV}       qa

*** Keywords ***

Load Environment
    Load Env    ${ENV}
    ${url}=  Get Env    baseurl
    Set Global Variable    ${BASE_URL}  ${url}

Capture Source Account

    ${SOURCE_ACCOUNT}=    Get Text
    ...    xpath=(//a[contains(@href,'activity')])[1]

    Set Suite Variable
    ...    ${SOURCE_ACCOUNT}

    Log To Console    Source Account: ${SOURCE_ACCOUNT}

Initialize API Suite
    Load Environment
    Open Application
    Create API Session
    Login To Application
    Get Customer ID From Account
    ...    ${SOURCE_ACCOUNT}
    Open New Account - Savings
    Capture Destination Account

Open Application
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window

Close Application
    Close Browser

#Capture Failure Screenshot
#
#    ${timestamp}=    Get Time    epoch
#    Take Screenshot
#    path=reports/screenshots/${timestamp}.png
#
#Wait Until Page Loads
#    Wait For Load State
