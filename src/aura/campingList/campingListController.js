/*****************************************
 * File: campingListController.js
 * Author: meruff
 * Description: Controller logic for
 ******************************************/
({
    doInit: function (component, event, helper) {
        var action = component.get("c.getItems");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var items = component.get("v.items");
                items.push(response.getReturnValue());
                component.set("v.items", items);
            }
        });
        $A.enqueueAction(action);
    },
    handleAddItem: function (component, event, helper) {
        var item = event.getParam("item");

        var theItems = component.get("v.items");
        var action = component.get("c.saveItem");
        action.setParams({
            "item": item
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                theItems.push(response.getReturnValue());
                component.set("v.items", theItems);
                component.set("v.newItem", "{ 'sobjectType':'Camping_Item__c', 'Name':'', 'Price__c':0, 'Quantity__c':0, 'Packed__c':false }");
            }
        });
        $A.enqueueAction(action);
    }
})