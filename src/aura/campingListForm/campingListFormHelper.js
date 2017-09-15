({
    createItem : function(component, newItem) {
        // fire event
        var addItem = component.getEvent("addItem");
        addItem.setParams({"item":newItem});
        addItem.fire();
        var newItemStr = "{\"sobjectType\":\"Camping_Item__c\",\"Name\":\"\",\"Price__c\":0,\"Quantity__c\":0,\"Packed__c\":false}";
        component.set("v.newItem", JSON.parse(newItemStr));
    }
})