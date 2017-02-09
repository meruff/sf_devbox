({
    createCampingItem: function(component, event, helper) {
        event.preventDefault();
        var validate = true;
        var nameField = component.find("itemName");
        var itemName = nameField.get("v.value");
        var quantityField = component.find("quantity");
        var quantity = quantityField.get("v.value");
        var priceField = component.find("price");
        var price = priceField.get("v.value");

        if ($A.util.isEmpty(itemName)){
            validate = false;
            nameField.set("v.errors", [{message:"Camping Item name can't be blank."}]);
        } else {
            nameField.set("v.errors", null);
        }

        if (quantity == 0) {
            validate = false;
            quantityField.set("v.errors", [{message:"Quantity can't be blank."}]);
        } else {
            quantityField.set("v.errors", null);
        }

        if (price == 0) {
            validate = false;
            priceField.set("v.errors", [{message:"Price can't be blank."}]);
        } else {
            priceField.set("v.errors", null);
        }

        if (validate) {
            var items = component.get("v.items");
            var item = component.get("v.newItem");
            console.log("Create expense: " + JSON.stringify(item));
            var newItem = JSON.parse(JSON.stringify(item));
            items.push(newItem);
            component.set("v.items", items);
            component.set("v.newItem", "{ sObjectType': 'Camping_Item__c', 'Name': '', 'Quantity__c': 0, 'Price__c': 0, 'Packed__c': false }");
            return false;
        }
    }
})