/*****************************************
* File: LeadProcessor
* Author: Mathew Ruff, Sierra-Cedar
* Description: Batch class to update all Leads with a new LeadSource (trailhead)
******************************************/
global class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT LeadSource ' +
            'FROM Lead'
        );
    }

    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
        }

        update scope;
    }

    global void finish(Database.BatchableContext bc) { }
}