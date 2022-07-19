/*****************************************
* File: TrailblazerListController
* Author: detonation0
* Description: Controller Logic for TrailblazerList.cmp
******************************************/
public class TrailblazerListController {
    /**
     * @description Queries for all Trailblazer records for display in the Component table.
     * @return a List of Trailblazer__c records for use in the Component.
     */
    @AuraEnabled
    public static List<Trailblazer__c> queryTrailblazers() {
        return [
            SELECT Id, Name, Badges__c, Points__c, Trailblazer_Since__c, Trails__c, Profile_Id__c,
                Profile_Link__c, Rank__c, Profile_Photo__c
            FROM Trailblazer__c
            ORDER BY Points__c DESC
        ];
    }
}