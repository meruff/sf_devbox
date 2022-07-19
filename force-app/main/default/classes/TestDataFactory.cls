/*****************************************
* File: TestDataFactory
* Author: meruff
* Description: Creates test data for Unit Tests
******************************************/
public class TestDataFactory
{
    /**
     * Creates a list of test Users for Apex Unit Tests.
     * @param Integer numOfUsers
     * @param Id profileId
     * @return List<User> users
     */
    public static List<User> createTestUsers(Integer numOfUsers, Id profileId)
    {
        List<User> users = new List<User>();

        for (Integer i = 0; i < numOfUsers; i++)
        {
            User u = new User(
                ProfileId = profileId,
                FirstName = 'Test' + i,
                LastName = 'User',
                Email = 'test' + i + '@nomail.com',
                UserName = 'test' + i + '@nomail.com.test',
                Alias = 'test' + i,
                TimeZoneSidKey = 'America/Phoenix',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            );

            users.add(u);
        }

        return users;
    }

    /**
     * Creates a list of test Contacts for Apex Unit Tests.
     * @param Integer numOfContacts
     * @return List<Contact> contacts
     */
    public static List<Contact> createTestContacts(Integer numOfContacts)
    {
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < numOfContacts; i++)
        {
            Contact c = new Contact(
                FirstName = 'Test' + i,
                LastName = 'Contact',
                Email = 'test' + i + '@nomail.com',
                MailingCity = 'Somewhere' + i,
                MailingState = 'AZ',
                MailingPostalCode = String.valueOf(Math.round(Math.random() * 100000))
            );

            contacts.add(c);
        }

        return contacts;
    }

    /**
     * Creates test Cases for the provided list of Contacts
     * @param List<Contact> contacts
     * @return List<Case> cases
     */
    public static List<Case> createTestCases(List<Contact> contacts, Integer numOfTestCasesPerContact)
    {
        List<Case> cases = new List<Case>();

        for (Contact con : contacts) {
            for (Integer i = 0; i < numOfTestCasesPerContact; i++)
            {
                Case c = new Case(
                    Subject = con.Name + '\'s test Case ' + i + '.',
                    Description = 'This is a test case. Please ignore this description.',
                    ContactId = con.Id
                );

                cases.add(c);
            }
        }

        return cases;
    }
}