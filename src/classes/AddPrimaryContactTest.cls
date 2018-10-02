/*****************************************
* File: AddPrimaryContactTest
* Author: meruff
* Description: Unit Tests for AddPrimaryContact.cls (trailhead)
******************************************/
@IsTest
private class AddPrimaryContactTest {
    static testMethod void testAddPrimaryContact() {
        // Arrange
        List<Account> testAccountsNY = new List<Account>();
        List<Account> testAccountsCA = new List<Account>();

        for (Integer i = 0; i < 50; i++) {
            Account accNY = new Account(
                Name = 'TestNY' + i,
                BillingState = 'NY'
            );
            testAccountsNY.add(accNY);
        }
        insert testAccountsNY;

        for (Integer i = 0; i < 50; i++) {
            Account accCA = new Account(
                Name = 'TestCA' + i,
                BillingState = 'CA'
            );
            testAccountsCA.add(accCA);
        }
        insert testAccountsCA;

        // Act 
        Test.startTest();
        System.enqueueJob(new AddPrimaryContact(new Contact(LastName = 'Test'), 'CA'));
        Test.stopTest();

        // Assert
        List<Contact> contactsToAssert = [SELECT Id FROM Contact];
        System.assert(contactsToAssert.size() == 50);
    }
}