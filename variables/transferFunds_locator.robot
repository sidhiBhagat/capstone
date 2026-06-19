*** Variables ***
${transfer_funds}    xpath= //a[text()="Transfer Funds"]
${amount}    xpath= //input[@id="amount"]
${from_account}    xpath= //select[@id="fromAccountId"]
${from_account_dropdown}    xpath= //select[@id="fromAccountId"]/option[1]
${to_account}    xpath= //select[@id="toAccountId"]
${to_account_dropdown}    xpath= //select[@id="toAccountId"]/option[3]
${transfer_btn}   xpath= //input[@value="Transfer"]