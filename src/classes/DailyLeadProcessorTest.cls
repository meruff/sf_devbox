/*****************************************
* File: DailyLeadProcessorTest
* Author: meruff
* Description: Unit Tests for DailyLeadProcessor.cls (trailhead)
******************************************/
@IsTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testMethod void testDailyLeadProcessor() {
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

        Map<Id, Lead> leadMap = new Map<Id, Lead>(testLeads);

        // Act 
        Test.startTest();
        String jobId = System.schedule('DailyLeadProcessorTest', CRON_EXP, new DailyLeadProcessor());
        Test.stopTest();

        // Assert
        List<Lead> leadsToAssert = [SELECT LeadSource FROM Lead];

        for (Lead l : leadsToAssert) {
            System.assert(l.LeadSource == 'Dreamforce');
        }
    }
}