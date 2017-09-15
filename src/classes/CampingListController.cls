/*****************************************
* File: CampingListController
* Author: Mathew Ruff, Sierra-Cedar
* Description: 
******************************************/
public class CampingListController {
    @AuraEnabled
    public static List<Camping_Item__c> getItems() {
        return [
            SELECT Name, Price__c, Quantity__c, Packed__c
            FROM Camping_Item__c
        ];
    }

    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item) {
        System.debug('merf: ' + item);
        insert item;
        return item;
    }
}