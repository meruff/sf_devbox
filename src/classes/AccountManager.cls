/*****************************************
* File: AccountManager
* Author: meruff
* Description: REST Service for Trailhead Module "Apex Web Services" found here:
* https://trailhead.salesforce.com/en/modules/apex_integration_services/units/apex_integration_webservices
******************************************/
@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        RestRequest req = RestContext.request;
        return [
            SELECT Id, Name, (SELECT Id, Name FROM Contacts)
            FROM Account
            WHERE Id = :req.requestURI.substringBetween('/Accounts/', '/contacts')
        ];
    }
}