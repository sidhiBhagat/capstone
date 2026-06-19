*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/pages/loginPage.robot
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../resources/keywords/api_keywords.robot
Suite Setup   Load Environment
Test Setup    Open Application
Test Teardown     Close Application

*** Test Cases ***
TC-PERF-UI-01 Verify Login Page Load Time

    Login To Application

    ${load_time}=    Execute Javascript
    ...    return (window.performance.timing.loadEventEnd - window.performance.timing.navigationStart)/1000;

    Log To Console    UI Load Time=${load_time}s

    Should Be True    ${load_time} < 5