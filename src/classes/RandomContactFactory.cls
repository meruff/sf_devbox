/*****************************************
* File: RandomContactFactory
* Author: Mathew Ruff, Sierra-Cedar
* Description: Random Contact Generator for Unit Tests
******************************************/
public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numOfContacts, String contLastName) {
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < numOfContacts; i++) {
            Contact c = new Contact(
                FirstName = 'Test ' + i,
                LastName = contLastName
            );
            contacts.add(c);
        }

        return contacts;
    }
}