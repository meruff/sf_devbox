({
    submitForm : function(component, event, helper) {
        var newItem = component.get("v.newItem");
        var nameField = component.find("itmname");
        var quantityField = component.find("itmquantity");
        var priceField = component.find("itmprice");

        if ($A.util.isEmpty(nameField.get("v.value"))) {
            nameField.set("v.errors", [{message:"Item name can't be blank."}]);
        } else if ($A.util.isEmpty(quantityField.get("v.value"))) {
            quantityField.set("v.errors", [{message:"Item quantity can't be blank."}]);
        } else if ($A.util.isEmpty(priceField.get("v.value"))) {
            priceField.set("v.errors", [{message:"Item price can't be blank."}]);
        } else {
            helper.createItem(component, newItem);
            nameField.set("v.errors", null);
            quantityField.set("v.errors", null);
            priceField.set("v.errors", null);
        }
    }
})