/*****************************************
* File: OrderEventTrigger
* Author: Mathew Ruff, Sierra-Cedar
* Description: Order_Event__e Trigger
******************************************/
trigger OrderEventTrigger on Order_Event__e (after insert) {
    List<Task> newTasks = new List<Task>();

    for (Order_Event__e e : (List<Order_Event__e>) Trigger.New) {
        if (e.Has_Shipped__c) {
            Task t = new Task(
                Priority = 'Medium',
                Status = 'New',
                Subject = 'Follow up on shipped order ' + e.Order_Number__c,
                OwnerId = '00561000000vZwF'
            );
            newTasks.add(t);
        }
    }

    if (newTasks.size() > 0) {
        insert newTasks;
    }
}