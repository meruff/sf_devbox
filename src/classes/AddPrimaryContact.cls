/*****************************************
* File: AddPrimaryContact
* Author: meruff
* Description: Inserts the same Contact for each Account for a specific state
******************************************/
public class AddPrimaryContact implements Queueable {
    private Contact c;
    private String state;

    public AddPrimaryContact(Contact cont, String abb) {
        this.c = cont;
        this.state = abb;
    }

    public void execute(QueueableContext context) {
        List<Contact> contactsToInsert = new List<Contact>();
        List<Account> accounts = new List<Account>([
            SELECT Id
            FROM Account
            WHERE BillingState = :state
            LIMIT 200
        ]);

        if (accounts.size() > 0) {
            for (Account a : accounts) {
                Contact cont = c.clone();
                cont.AccountId = a.Id;
                contactsToInsert.add(cont);
            }
        }

        if (contactsToInsert.size() > 0) {
            insert contactsToInsert;
        }
    }
}