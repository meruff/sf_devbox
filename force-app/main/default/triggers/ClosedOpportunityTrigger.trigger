trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> newTasks = new List<Task>();

    for (Opportunity o : Trigger.new) {
        if (o.StageName == 'Closed Won') {
            Task t = new Task(
                Subject = 'Follow Up Test Task',
                WhatId = o.Id
            );
            newTasks.add(t);
        }
    }

    if (newTasks.size() > 0) {
        insert newTasks;
    }
}