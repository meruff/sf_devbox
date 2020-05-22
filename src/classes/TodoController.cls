/**
* @author Mathew Ruff, Sierra-Cedar
* @date 9/10/19
*
* 
*/
public class TodoController {
    @AuraEnabled
    public static List<Task__c> getTasks() {
        return [
            SELECT Id,
                Due_Date__c,
                Priority__c,
                Title__c,
                Completed__c
            FROM Task__c
            WHERE User__c = :UserInfo.getUserId()
            ORDER BY Priority__c, Due_Date__c ASC
        ];
    }
}