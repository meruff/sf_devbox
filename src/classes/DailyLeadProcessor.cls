/*****************************************
* File: DailyLeadProcessor
* Author: meruff
* Description: Updates Lead records with a specific LeadSource (trailhead)
******************************************/
global class DailyLeadProcessor implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Lead> leads = new List<Lead>([
            SELECT LeadSource
            FROM Lead
            WHERE LeadSource = null
            LIMIT 200
        ]);

        if (leads.size() > 0) {
            for (Lead l : leads) {
                l.LeadSource = 'Dreamforce';
            }

            update leads;
        }
    }
}