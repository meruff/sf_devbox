/*****************************************
* File: ReassignCoachesController
* Author: meruff
* Description: Custom Controller for ReassignCoaches.page
******************************************/
public with sharing class ReassignCoachesController
{
    public Integer page { get; set; }
    public List<User> users { get; set; }
    public List<Contact> contacts { get; set; }
    public String searchString { get; set; }
    public String transferSelection { get; set; }

    public ReassignCoachesController() {
        // Initialize lists
        users = new List<User>();
        contacts = new List<Contact>();
        page = 1;
    }

    public List<SelectOption> getTransferOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        options.add(new SelectOption('Student', 'Student'));
        options.add(new SelectOption('Coach', 'Coach'));
        return options;
    }

    public void coachSearch()
    {
        if (searchString.length() < 2)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Search length must be at least 2 characters'));
            return;
        }

        users = new List<User>();
        contacts = new List<Contact>();

        String soslString = '' +
            'FIND \'' + String.escapeSingleQuotes(searchString) + '*\' ' +
            'IN ALL FIELDS RETURNING ' +
            'User(Id, Name)';

        List<List<SObject>> results = Search.query(soslString);

        if (!results.isEmpty())
        {
            if (!results[0].isEmpty())
            {
                users = results[0];
            }
        }
    }

    public void contactSearch() {
        if (searchString.length() < 2)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Search length must be at least 2 characters'));
            return;
        }

        users = new List<User>();
        contacts = new List<Contact>();

        String soslString = '' +
            'FIND \'' + String.escapeSingleQuotes(searchString) + '*\' ' +
            'IN ALL FIELDS RETURNING ' +
            'Contact(Id, Name)';

        List<List<SObject>> results = Search.query(soslString);

        if (!results.isEmpty())
        {
            if (!results[0].isEmpty())
            {
                contacts = results[0];
            }
        }
    }

    public void selectPage() {
        if (transferSelection == 'Student') page2();
        if (transferSelection == 'Coach') page3();
    }

    public void page1()
    {
        page = 1;
    }

    public void page2()
    {
        page = 2;
    }

    public void page3()
    {
        page = 3;
    }
}