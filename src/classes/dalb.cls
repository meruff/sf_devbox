/*****************************************
* File: dalb
* Author: detonation0
* Description: A custom webservice for Slack
******************************************/
@RestResource(urlMapping='/dalb/*')
global class dalb {
    public static List<String> responses {
        get {
            if (responses == null) {
                responses = new List<String>{
                    'I\'m sofa king tired.',
                    'I really hope I win the lottery.',
                    'I have too much to do tonight.',
                    'I\'m exhausted already.',
                    'I have nothing better to do.',
                    'Sometimes a man just needs a horse wiener in his mouth',
                    'I just dgaf anymore, truck is gonna truck',
                    'Remember remember the 5th of November. The Jenkies Carrot and Frot. I know of no reason the Baby Carrot should ever be forgot.',
                    'You think I\'m busy? I\'m going to stare at a wall tonight.',
                    'I need to make a slackbot that just `/dalb` and it inserts a random complaint',
                    'I am so happy that I am such a nice guy.',
                    'Gonna end up missing my flight cuz of some fucking moron.',
                    'God dammit.',
                    'I\'m shaking mad.',
                    'Plane boards in 20 minutes. Fucking faggots aren\'t even at the airport yet.',
                    'Cuz I am fagoo.',
                    'I want culver\'s.',
                    'In Vegas: Should I just go off myself on the strip?',
                    'I don\'t know what I\'m doing anymore.',
                    'I hunger.',
                    'I can\'t make it today.',
                    'I had the worst soft pretzel of my life.'
                };
            }

            return responses;
        }

        set;
    }

    @HttpGet
    global static void getComplaint() {
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

        responseString = '' +
            '{' +
                '"response_type":"in_channel",' +
                '"text":"' + response + '"' +
            '}';
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(responseString);
    }
}