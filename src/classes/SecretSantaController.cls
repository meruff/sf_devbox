/*****************************************
* File: SecretSantaController
* Author: detonation0
* Description: Controller for secretSanta.page
******************************************/
public without sharing class SecretSantaController {
    public Map<String, Secret_Santa__c> secretSantaMap { get; set; }
    public Integer page { get; set; }
    public Set<String> playersStillLeft { get; set; }
    public Set<String> alreadyPickedNamesForGifts { get; set; }
    public String currentlySelectedUser { get; set; }
    public String currentPlayersString { get; set; }
    public String randomlySelectedGiftee { get; set; }
    public String email { get; set; }

    public SecretSantaController() {
        page = 1;
        playersStillLeft = new Set<String>();
        alreadyPickedNamesForGifts = new Set<String>();
        secretSantaMap = new Map<String, Secret_Santa__c>();
        currentlySelectedUser = '';
        currentPlayersString = '';
        randomlySelectedGiftee = '';
        email = '';
        Integer numOfPlayers = 0;

        List<Secret_Santa__c> allSecretSantas = new List<Secret_Santa__c>([
            SELECT Name, Secret_Santa_Wants__c, Secret_Santa_Giftee__c, Secret_Santa_Giftee__r.Name
            FROM Secret_Santa__c
        ]);

        for (Secret_Santa__c ss : allSecretSantas) {
            secretSantaMap.put(ss.Name, ss);

            if (String.isEmpty(ss.Secret_Santa_Giftee__c)) {
                playersStillLeft.add(ss.Name);
            } else {
                numOfPlayers++;
                alreadyPickedNamesForGifts.add(ss.Secret_Santa_Giftee__r.Name);
            }
        }

        System.debug('merf secretSantaMap: ' + secretSantaMap);

        if (numOfPlayers == 0) {
            currentPlayersString = 'There are currently no players signed up to play...';
        } else {
            currentPlayersString = 'There are currently ' + numOfPlayers + ' people who have signed up to play...';
        }
    }

    /**
     * Generates a List of Named SelectOptions for the User to select from.
     *
     * @return options, the List of SelectOptions.
     */
    public List<SelectOption> getNameOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));

        for (String s : playersStillLeft) {
            options.add(new SelectOption(s, s));
        }

        return options;
    }

    /**
     * Generates a random Giftee for the Secret Santa and assigns them.
     */
    public void generateGifteeAndAssign() {
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter an email address in the proper format.'));
            return;
        }

        System.debug('merf person selected as SS: ' + currentlySelectedUser);
        System.debug('merf alreadyPickedNames: ' + alreadyPickedNamesForGifts);

        // Randomly select a giftee and assign them to the Secret Santa.
        List<String> allNames = new List<String>(secretSantaMap.keySet());
        List<String> gifteesLeftToChooseFrom = new List<String>();

        for (String s : allNames) {
            if (!alreadyPickedNamesForGifts.contains(s)) {
                gifteesLeftToChooseFrom.add(s);
            }
        }

        if (playersStillLeft.size() == 2 && new Set<String>(gifteesLeftToChooseFrom).contains(currentlySelectedUser)) {
            for (String s : gifteesLeftToChooseFrom) {
                if (!s.equals(currentlySelectedUser)) {
                    randomlySelectedGiftee = s;
                }
            }
        } else {
            do {
                randomlySelectedGiftee = gifteesLeftToChooseFrom[Integer.valueOf(Math.random() * (gifteesLeftToChooseFrom.size()))];
            } while (currentlySelectedUser == randomlySelectedGiftee || alreadyPickedNamesForGifts.contains(randomlySelectedGiftee));
        }

        // Update the Secret Santa with the email provided by the User.
        Secret_Santa__c ssToUpdate = secretSantaMap.get(currentlySelectedUser);
        ssToUpdate.Secret_Santa_Giftee__c = secretSantaMap.get(randomlySelectedGiftee).Id;
        ssToUpdate.SS_Email__c = email;

        try {
            update ssToUpdate;

            // Create success email and send
            EmailService.sendMail(EmailService.createSSEmail(email, currentlySelectedUser, secretSantaMap.get(randomlySelectedGiftee)));
            page4();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR! Please let Mat know, here\'s the message:' + e.getMessage() + e.getLineNumber()));
        }
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