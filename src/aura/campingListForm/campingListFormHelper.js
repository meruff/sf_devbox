/*****************************************
 * File: campingListFormHelper.js
 * Author: meruff
 * Description: Helper logic for
 ******************************************/
({
    createItem: function (component, item) {
        var addItem = component.getEvent("addItem");
        addItem.setParams({ "item": item });
        addItem.fire();
        component.set("v.newItem", "{ 'sobjectType':'Camping_Item__c', 'Name':'', 'Price__c':0, 'Quantity__c':0, 'Packed__c':false }");
    }
})