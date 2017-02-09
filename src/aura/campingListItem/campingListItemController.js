({
    packItem: function(component, event, helper) {
        if (!component.get("v.item.Packed__c")) {
            var item = component.get("v.item"); // instantiate the item first.
            item.Packed__c = true; // manipulate the item.
            component.set("v.item", item); // set item back to component.
            event.getSource().set("v.disabled", true); // disable button.
            // Note that shorthand component.set("v.item.Packed__c", true); did NOT work.
        }
    }
})