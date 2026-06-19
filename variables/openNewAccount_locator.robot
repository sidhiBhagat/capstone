*** Variables ***
${open_new_account}    xpath= //a[contains(text(),'Open New Account')]
${account_type}    xpath= //select[@id="type"]
${account_type_dropdown}    xpath= //option[text()="SAVINGS"]
${account_type_dropdown2}    xpath= //option[text()="CHECKING"]
${from_account}    xpath= //select[@id="fromAccountId"]
#${from_account_dropdown}    xpath= //select[@id="fromAccountId"]//option[5]
${submit_btn}   xpath= //input[@value="Open New Account"]
${NEW_ACCOUNT_ID_LABEL}    id=newAccountId