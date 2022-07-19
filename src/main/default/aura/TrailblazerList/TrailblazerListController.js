/*****************************************
 * File: TrailblazerListController.js
 * Author: detonation0
 * Description: Controller logic for TrailblazerList.cmp
 ******************************************/
({
    loadTrailblazers : function(cmp, event, helper) {
        document.title = "Trailhead Leaderboard";
        var action = cmp.get("c.queryTrailblazers");
        action.setCallback(this, function (response) {
            cmp.set("v.trailblazers", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})