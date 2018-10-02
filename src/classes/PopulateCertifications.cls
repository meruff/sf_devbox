/*****************************************
* File: PopulateCertifications
* Author: meruff
* Description: Class to callout to the Salesforce Certificatoin Site and populate Salesforce_Certifications__c
******************************************/
global class PopulateCertifications implements Schedulable {
    private static final String CALLOUT_URL = 'http://certification.salesforce.com/certification-detail-print?conId=';

    global void execute(SchedulableContext SC) {
        findCertifications();
    }

    public PopulateCertifications() {
        findCertifications();
    }

    @future(callout=true)
    public static void findCertifications() {
        Map<String, Contact> contactMap = new Map<String, Contact>();

        List<Contact> contacts = new List<Contact>([
            SELECT Name, Certification_Contact_Id__c,
                (
                    SELECT Id, Certification_Name__c, Certification_Date__c, Certification_Logo_URL__c 
                    FROM Salesforce_Certifications__r
                )
            FROM Contact
            WHERE Show_On_Certification_Site__c = true
        ]);

        if (contacts.size() > 0) {
            for (Contact con : contacts) {
                contactMap.put(con.Certification_Contact_Id__c, con);
            }

            calloutToCertSite(contactMap);
        }
    }

    public static void calloutToCertSite(Map<String, Contact> contactMap) {
        List<Contact> contactsToUpdate = new List<Contact>();
        List<ContactCertWrapper> contactWrappers = new List<ContactCertWrapper>();

        for (String salesforceContactId : contactMap.keySet()) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CALLOUT_URL + salesforceContactId);
            req.setMethod('GET');
            HttpResponse res = h.send(req);

            ContactCertWrapper ccw = new ContactCertWrapper();

            if (contactMap.containsKey(salesforceContactId)) {
                ccw.c = contactMap.get(salesforceContactId);
            }

            ccw = populateCCW(res.getBody(), ccw);
            contactWrappers.add(ccw);
        }

        if (contactWrappers.size() > 0) {
            List<Contact> contactsToUpsert = new List<Contact>();
            List<Salesforce_Certification__c> certifications = new List<Salesforce_Certification__c>();

            for (ContactCertWrapper ccw : contactWrappers) {
                contactsToUpsert.add(ccw.c);
            }

            if (contactsToUpdate.size() > 0) upsert contactsToUpsert;

            for (ContactCertWrapper ccw : contactWrappers) {
                for (Salesforce_Certification__c sc : ccw.certs) {
                    Boolean isDupe = false;
                    sc.Contact__c = ccw.c.Id;

                    if (contactMap.containsKey(ccw.c.Certification_Contact_Id__c)) {
                        for (Salesforce_Certification__c check : contactMap.get(ccw.c.Certification_Contact_Id__c).Salesforce_Certifications__r) {
                            if (check.Certification_Name__c == sc.Certification_Name__c) {
                                isDupe = true;
                                check.Certification_Name__c = sc.Certification_Name__c;
                                check.Certification_Date__c = sc.Certification_Date__c;
                                certifications.add(check);
                            }
                        }
                    }

                    if (!isDupe) certifications.add(sc);
                }
            }

            if (certifications.size() > 0) upsert certifications;
        }
    }

    public static ContactCertWrapper populateCCW(String resBody, ContactCertWrapper ccw) {
        ccw.c.Show_On_Certification_Site__c = true;
        Integer indexOfName = resBody.indexOf('data-full-name=');
        String fullName = resBody.substring(indexOfName).substringBetween(
            '\"',
            '\"'
        );
        fullName = fullName.trim();
        String[] temp = fullName.split(' ');
        String firstName = temp[0];
        String lastName = temp[1];
        ccw.c.FirstName = firstName;
        ccw.c.LastName = lastName;

        Integer lastIndexOfCert = 0;

        for (Integer i = 0; i < resBody.countMatches('ver-search-results-line'); i++) {
            Salesforce_Certification__c sc = new Salesforce_Certification__c();

            Integer indexOfCert = resBody.indexOf('id=\"cert-name\"') + lastIndexOfCert;
            String certName = resBody.substring(indexOfCert + lastIndexOfCert).substringBetween(
                '>',
                '<'
            ).trim();
            sc.Certification_Name__c = certName;

            String subbed = resBody.substring(indexOfCert + lastIndexOfCert);
            Integer indexOfDate = subbed.indexOf('class=\"date-certified"');
            String dateCertified = subbed.substring(indexOfDate).substringBetween(
                'class="date-certified">',
                '<'
            ).trim();
            sc.Certification_Date__c = dateCertified;

            ccw.certs.add(sc);
            lastIndexOfCert += 184;
        }

        return ccw;
    }

    public class ContactCertWrapper {
        public Contact c { get; set; }
        public List<Salesforce_Certification__c> certs { get; set; }
        public Integer validCertCount { get; set; }
        public Integer invalidCertCount { get; set; }

        public ContactCertWrapper() {
            c = new Contact();
            certs = new List<Salesforce_Certification__c>();
            validCertCount = 0;
            invalidCertCount = 0;
        }
    }
}