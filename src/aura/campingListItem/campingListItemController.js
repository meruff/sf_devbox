/*****************************************
 * File: campingListItemController.js
 * Author: meruff
 * Description: Controller logic for
 ******************************************/
({
    packItem: function(component, event, helper) {
        var btn = event.getSource();
        var item = component.get("v.item");
        btn.set("v.disabled", true);
        item.Packed__c = true;
        component.set("v.item", item);
    }
})