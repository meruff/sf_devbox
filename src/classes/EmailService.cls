/*****************************************
* File: EmailService
* Author: meruff
* Description: Simple Email Messaging Serivce Class
******************************************/
public class EmailService {
    public static Messaging.SingleEmailMessage createSSEmail(String toAdd, String toName, Secret_Santa__c selectedGiftee) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{ toAdd });
        email.setReplyTo('mathew.ruff@gmail.com');
        email.setSenderDisplayName('Mathew Ruff');
        email.setSubject('Ruff Secret Santa 2017');

        String body = '' +
            'Hello ' + toName + '!<br /><br />' +
            'You got ' + selectedGiftee.Name + ' as your Secret Santa giftee! This email is just a reminder in case ' +
            'you forget who you got. Remember, gifts are no more than $50.<br /><br />';

        if (selectedGiftee.Secret_Santa_Wants__c != '') {
            body += 'Here are some items ' + selectedGiftee.Name + ' would want for Xmas to help you out:<br />' +
                selectedGiftee.Secret_Santa_Wants__c + '<br/>';
        }

        body += 'Thanks for playing,<br /><br />Mat';
        email.setHtmlBody(body);

        return email;
    }

    public static void sendMail(Messaging.SingleEmailMessage email) {
        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        } catch (EmailException e) {
            throw new EmailException('ERROR: ' + e.getMessage());
        }
    }

    public static void sendMail(List<Messaging.SingleEmailMessage> emails) {
        try {
            Messaging.sendEmail(emails);
        } catch (EmailException e) {
            throw new EmailException('ERROR: ' + e.getMessage());
        }
    }

    public class EmailException extends Exception { }
}