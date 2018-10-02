/**
* @author meruff
* @date 8/27/18
*
* Controller Logic for DirectMessage.cmp
*/
public class DirectMessageController {
    @AuraEnabled
    public static String sendMessage(String jsonString) {
        System.debug('merf jsonString: ' + jsonString);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v43.0/chatter/users/me/messages');
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonString);

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('merf: ' + res);

        return '';
    }
}