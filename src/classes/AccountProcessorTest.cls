/*****************************************
* File: AccountProcessorTest
* Author: meruff
* Description: Unit Tests for AccountProcessor.cls
******************************************/
@IsTest
private class AccountProcessorTest {
    static testMethod void testAccountProcessing() {
        // Arrange
        Account testAccount = new Account(
            Name = 'Some Account'
        );
        insert testAccount;

        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            Contact c = new Contact(
                LastName = 'Test' + i,
                AccountId = testAccount.Id
            );
            testContacts.add(c);
        }
        insert testContacts;

        // Act
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{ testAccount.Id });
        Test.stopTest();

        Account a = [SELECT Number_Of_Contacts__c FROM Account LIMIT 1];

        // Assert
        System.assert(a.Number_Of_Contacts__c == 10);
    }
}