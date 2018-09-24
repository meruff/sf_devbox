/*****************************************
 * File: DirectMessageController.js
 * Author: Mathew Ruff, Sierra-Cedar
 * Description: Controller logic for DirectMessage.cmp
 ******************************************/
({
    toggleModal: function (component, event, helper) {
        $A.util.toggleClass(component.find("backdrop"), "slds-backdrop--open");
        $A.util.toggleClass(component.find("messageModal"), "slds-fade-in-open");
    },
    sendMessageToController: function (component, event, helper) {
        var directMessage = {
            subject: component.get("v.subject"),
            body: component.get("v.body"),
            recipients: [$A.get("$SObjectType.CurrentUser.Id"), "00561000001pnLH"]
        };
        console.log("json message: " + JSON.stringify(directMessage));

        var action = component.get("c.sendMessage");
        action.setParams({jsonString: JSON.stringify(directMessage)});
        action.setCallback(this, function (response) {
            console.log("state: " + response.getState());
            if (response.getState() === "SUCCESS") {

            }
        });
        $A.enqueueAction(action);
    }
})