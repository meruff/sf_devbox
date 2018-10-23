/*****************************************
* File: AccountManagerTest
* Author: Mathew Ruff, Sierra-Cedar
* Description: Unit Tests for AccountManager.cls
******************************************/
@IsTest
private class AccountManagerTest {
    static testMethod void testGetAccountById() {
        // Arrange
        Account testAccount = new Account(
            Name = 'Super Gary'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Super',
            LastName = 'Man',
            Email = 'super.man@hooli.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Act
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://merf-dev-ed.lightning.salesforce.com/services/apexrest/Accounts/' + testAccount.Id + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Account assertAccount = AccountManager.getAccount();
        Test.stopTest();

        // Assert
        System.assert(assertAccount != null);
        System.assertEquals('Super Gary', assertAccount.Name);
        System.assertEquals('Super Man', assertAccount.Contacts[0].Name);
    }
}