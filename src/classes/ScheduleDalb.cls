/*****************************************
* File: ScheduleDalb
* Author: Mathew Ruff, Sierra-Cedar
* Description: Post dalb complains as Slackbot whenever this class is scheduled.
******************************************/
global class ScheduleDalb implements Schedulable {
    public static String[] responses = dalb.responses;

    global void execute(SchedulableContext sc) {
        // Schedulable context only
        postCompliantToSlackbot();
    }

    public static void postCompliantToSlackbot() {
        Dalb_Complains__c dalb = [SELECT Last_Response__c FROM Dalb_Complains__c WHERE Name = 'Main'];
        String responseString = '';
        String response = responses[(Math.random() * responses.size()).intValue()];

        if (dalb != null && !String.isEmpty(dalb.Last_Response__c)) {
            List<String> temp = dalb.Last_Response__c.split(';');
            Set<String> responseList = new Set<String>();
            responseList.addAll(temp);

            while (responseList.contains(response)) {
                response = responses[(Math.random() * responses.size()).intValue()];
            }

            dalb.Last_Response__c = temp[1] + ';' + response;
            update dalb;
        }

        postAsSlackbot(response);
    }

    @future(callout=true)
    global static void postAsSlackbot(String message) {
        String jsonMessage = '' +
            '{' +
                '"text":"' + String.escapeSingleQuotes(message) + '",' +
                '"username":"dalb-complains",' +
                '"icon_emoji":":bc:"' +
            '}';

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://hooks.slack.com/services/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');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(jsonMessage);
        HttpResponse res = h.send(req);
        if (res.getStatus() != '200') {
            System.debug('merf DALB COMPLAINS SLACKBOT ERROR: ' + res);
            System.debug('merf REQ BODY: ' + req.getBody());
        }
    }
}