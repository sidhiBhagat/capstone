*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../resources/keywords/common_resources.robot
Test Setup      Open Application
Test Teardown      Close Application
*** Test Cases ***
TC-NEG-API-01 GET Accounts Without Authentication
    ${headers}=  Create Dictionary
    ...     Accept=application/json
    Create Session
    ...    unauth
    ...    https://parabank.parasoft.com
    ...    headers= ${headers}

    ${response}=    GET On Session
    ...    unauth
    ...    /parabank/services/bank/customers/12212/accounts
    ...    expected_status=any


    Log To Console    Status Code: ${response.status_code}

    Log To Console    Response: ${response.text}

TC-NEG-API-02 GET Accounts Invalid Customer ID

    Create Session
    ...    parabank
    ...    https://parabank.parasoft.com

    ${response}=    GET On Session
    ...    parabank
    ...    /parabank/services/bank/customers/99999999/accounts
    ...    expected_status=any

    Should Be True
    ...    ${response.status_code} == 400 or ${response.status_code} == 404