/*****************************************
* File: AccountProcessor
* Author: Mathew Ruff, Sierra-Cedar
* Description: Class to process accounts (Trailhead)
******************************************/
public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accIds) {
        Map<Id, List<Contact>> acctToContactsByIds = new Map<Id, List<Contact>>();
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Number_Of_Contacts__c
            FROM Account
            WHERE Id IN :accIds
        ]); 

        List<Contact> contacts = new List<Contact>([
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accIds
        ]);

        for (Contact c : contacts) {
            if (!acctToContactsByIds.containsKey(c.AccountId)) {
                acctToContactsByIds.put(c.AccountId, new List<Contact>{ c });
            } else {
                acctToContactsByIds.get(c.AccountId).add(c);
            }
        }

        if (acctToContactsByIds.size() > 0) {
            for (Id acctId : acctToContactsByIds.keySet()) {
                accountMap.get(acctId).Number_Of_Contacts__c = acctToContactsByIds.get(acctId).size();
            }

            update accountMap.values();
        }
    }
}