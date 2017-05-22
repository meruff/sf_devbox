/*****************************************
* File: LeadProcessorTest
* Author: Mathew Ruff, Sierra-Cedar
* Description: Unit Tests for LeadProcessor.cls (trailhead)
******************************************/
@IsTest
private class LeadProcessorTest {
    static testMethod void testLeadProcessorBatch() {
        // Arrange
        List<Lead> testLeads = new List<Lead>();

        for (Integer i = 0; i < 200; i++) {
            Lead l = new Lead(
                LastName = 'Test' + i,
                Company = 'Company' + i
            );
            testLeads.add(l);
        }
        insert testLeads;

        // Act 
        Test.startTest();
        Database.executeBatch(new LeadProcessor());
        Test.stopTest();

        // Assert
        List<Lead> leadsToAssert = [SELECT LeadSource FROM Lead];

        for (Lead l : leadsToAssert) {
            System.assert(l.LeadSource == 'Dreamforce');
        }
    }
}