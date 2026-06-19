*** Settings ***
Resource    ../../resources/keywords/common_resources.robot

Suite Setup   Initialize API Suite


*** Test Cases ***
TC-PERF-API-01 Verify Accounts API Response Time

    ${response}=    Get Customer Accounts    ${CUSTOMER_ID}

    ${response_time}=    Set Variable
    ...    ${response.elapsed.total_seconds()}

    Log To Console    API Response Time=${response_time}s

    Should Be True    ${response_time} < 2