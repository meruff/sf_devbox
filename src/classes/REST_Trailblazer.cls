/**
* @author meruff
* @date 9/26/18
*
* Exposes Trailblazer records.
*/
@RestResource(urlMapping='/trailblazers/*')
global class REST_Trailblazer {
    @HttpGet
    global static void getTrailblazers() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(
            JSON.serialize([
                SELECT Name, Points__c, Rank__c, Badges__c, Trails__c, Trailblazer_Since__c,
                    Profile_Id__c, Profile_Link__c, Profile_Photo__c, Job_Title__c, Company_Institution__c,
                    (SELECT Id, Name FROM Badges__r)
                FROM Trailblazer__c
            ])
        );
    }
}