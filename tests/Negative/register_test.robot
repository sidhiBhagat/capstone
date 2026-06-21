*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/keywords/common_resources.robot
Resource    ../../variables/register_locator.robot

Suite Setup  Load Environment
Test Setup   Open Application
Test Teardown    Close Application
*** Test Cases ***
TC-NEG-REG-01 Registration Required Fields Empty

    Click Element    ${register_link}

    Click Element    ${register_btn}

    Page Should Contain    First name is required.
    Page Should Contain    Last name is required.
    Page Should Contain    Address is required.
    Page Should Contain    City is required.
    Page Should Contain    State is required.
    Page Should Contain    Zip Code is required.
    Page Should Contain    Social Security Number is required.
    Page Should Contain    Username is required.
    Page Should Contain    Password is required.
    Page Should Contain    Password confirmation is required.

    Page Should Not Contain    Your account was created successfully.

TC-NEG-REG-02 Password And Confirm Password Mismatch
    Wait Until Element Is Visible    ${register_link}
    Click Element    ${register_link}

    Input Text    ${first_name}         Test
    Input Text    ${last_name}          User
    Input Text    ${address}            Jaipur
    Input Text    ${city}               Jaipur
    Input Text    ${state}              Rajasthan
    Input Text    ${zip_code}           302001
    Input Text    ${ssn}                123456789
    Input Text    ${username}           testuser123
    Input Text    ${password}           Test@123
    Input Text    ${confirm_password}   Test@999
    Wait Until Element Is Enabled    ${register_btn}
    Click Element    ${register_btn}

#    Page Should Contain    Passwords did not match.

    Page Should Not Contain
    ...    Your account was created successfully.