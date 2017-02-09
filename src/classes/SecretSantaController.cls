/*****************************************
* File: SecretSantaController
* Author: meruff
* Description: Controller for secretSanta.page
******************************************/
public without sharing class SecretSantaController {
    private static final Set<String> PLAYERS = new Set<String>{ 'Mathew', 'Michael', 'Daniel', 'Eric', 'Christine', 'Charlene' };

    public Integer page { get; set; }
    public Set<String> names { get; set; }
    public String selectedName { get; set; }
    public String currentPlayers { get; set; }
    public String selectedGiftee { get; set; }
    public String email { get; set; }

    public SecretSantaController() {
        page = 1;
        names = PLAYERS;
        currentPlayers = '';
        List<Secret_Santa__c> existingPlayers = new List<Secret_Santa__c>();

        existingPlayers = [
            SELECT Secret_Santa__c, Giftee__c
            FROM Secret_Santa__c
        ];

        for (Secret_Santa__c ss : existingPlayers) {
            if (names.contains(ss.Secret_Santa__c)) {
                names.remove(ss.Secret_Santa__c);
            }
        }

        if (existingPlayers.size() == 0) {
            currentPlayers = 'There are currently no players signed up to play...';
        } else {
            currentPlayers = 'There are currently ' + existingPlayers.size() + ' people who have signed up to play...';
        }
    }

    public List<SelectOption> getNameOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));

        for (String s : names) {
            options.add(new SelectOption(s, s));
        }

        return options;
    }

    public void generateGiftee() {
        // copypasta
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an email address in the proper format.'));
            return;
        }

        List<String> randList = new list<String>(names);

        do {
            selectedGiftee = randList[Integer.valueOf(Math.random() * (randList.size()))];
        } while (selectedGiftee == selectedName);

        insertGiftee();
    }

    public void insertGiftee() {
        Secret_Santa__c newSS = new Secret_Santa__c(
            Name = selectedName + ' ' + System.now(),
            Secret_Santa__c = selectedName,
            Giftee__c = selectedGiftee,
            SS_Email__c = email
        );

        try {
            insert newSS;
            createSuccessEmail();
            page4();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: Problem inserting secret Santa, please tell Mat.'));
        }
    }

    public void createSuccessEmail() {
        Messaging.SingleEmailMessage email = EmailService.createSSEmail(email, selectedName, selectedGiftee);
        EmailService.sendMail(email);
    }

    public void page1() {
        page = 1;
    }

    public void page2() {
        page = 2;
    }

    public void page3() {
        page = 3;
    }

    public void page4() {
        page = 4;
    }
}