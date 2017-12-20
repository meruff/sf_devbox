/*****************************************
 * File: campingListFormController.js
 * Author: Mathew Ruff, Sierra-Cedar
 * Description: Controller logic for
 ******************************************/
({
    clickCreateItem: function (component, event, helper) {
        var validExpense = component.find("itemForm").reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        // If we pass error checking, do some real work
        if (validExpense){
            helper.createItem(component, component.get("v.newItem"));
        }
    }
})