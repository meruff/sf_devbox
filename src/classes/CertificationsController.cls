/*****************************************
* File: CertificationsController
* Author: Mathew Ruff, Sierra-Cedar
* Description: 
******************************************/
public class CertificationsController {
    private static final String CALLOUT_URL = 'http://certification.salesforce.com/certification-detail-print?conId=';
    private Map<String, Contact> contactMap;
    public Integer sciCertCount { get; set; }
    public Contact newContact { get; set; }
    public List<PopulateCertifications.ContactCertWrapper> ccws { get; set; }

    public static Integer PARTNER_CERT_COUNT {
        get {
            if (PARTNER_CERT_COUNT == null) {
                PARTNER_CERT_COUNT = 25;
            }

            return PARTNER_CERT_COUNT;
        }
        set;
    }

    public static Set<String> NON_VALID_CERTS {
        get {
            if (NON_VALID_CERTS == null) {
                NON_VALID_CERTS = new Set<String>{
                    'Salesforce Certified Administrator',
                    'Salesforce Certified Advanced Administrator',
                    'Salesforce Certified Force.com Developer'
                };
            }

            return NON_VALID_CERTS;
        }

        set;
    }

    public CertificationsController() {
        populateContacts();
    }

    public void populateContacts() {
        sciCertCount = 0;
        newContact = new Contact();
        contactMap = new Map<String, Contact>();
        ccws = new List<PopulateCertifications.ContactCertWrapper>();

        List<Contact> contacts = new List<Contact>([
            SELECT Name, Certification_Contact_Id__c,
            (
                SELECT Id, Certification_Name__c, Certification_Date__c, Certification_Logo_URL__c
                FROM Salesforce_Certifications__r
                ORDER BY Certification_Name__c ASC
            )
            FROM Contact
            WHERE Show_On_Certification_Site__c = true
            ORDER BY Name ASC
        ]);

        if (contacts.size() > 0) {
            for (Contact con : contacts) {
                contactMap.put(con.Certification_Contact_Id__c, con);
            }
        }

        for (Contact c : contacts) {
            Integer validCerts = 0;
            Integer invalidCerts = 0;

            for (Salesforce_Certification__c sc : c.Salesforce_Certifications__r) {
                if (!NON_VALID_CERTS.contains(sc.Certification_Name__c)) {
                    sciCertCount++;
                    validCerts++;
                } else {
                    invalidCerts++;
                }
            }

            PopulateCertifications.ContactCertWrapper ccw = new PopulateCertifications.ContactCertWrapper();
            ccw.c = c;
            ccw.certs.addAll(c.Salesforce_Certifications__r);
            ccw.validCertCount = validCerts;
            ccw.invalidCertCount = invalidCerts;
            ccws.add(ccw);
        }
    }

    public void createNewContact() {
        if (newContact.Certification_Contact_Id__c.length() > 18 || newContact.Certification_Contact_Id__c.length() < 18) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'Certification Contact Ids must be 18 characters in length.'));
            return;
        }

        if (String.isEmpty(newContact.Email) || String.isEmpty(newContact.Certification_Contact_Id__c)) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'You must enter your Email and Certification Contact Id in order to be added to the board.'));
            return;
        }

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(CALLOUT_URL + newContact.Certification_Contact_Id__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        if (!res.getBody().contains('No Active Certification Credentials Found')) {
            List<Salesforce_Certification__c> certifications = new List<Salesforce_Certification__c>();
            PopulateCertifications.ContactCertWrapper ccw = new PopulateCertifications.ContactCertWrapper();
            ccw.c = newContact;
            ccw = PopulateCertifications.populateCCW(res.getBody(), ccw);

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

            try {
                upsert ccw.c Certification_Contact_Id__c;

                if (certifications.size() > 0) {
                    for (Salesforce_Certification__c sc : certifications) {
                        sc.Contact__c = ccw.c.Id;
                    }

                    upsert certifications;
                }

                populateContacts();
            }
            catch (DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.Error,
                    'ERROR during creation. Please try again later ' + e.getMessage()));
                return;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.Error,
                'Either you have no active credentials, or could not find a User for this Id: ' +
                newContact.Certification_Contact_Id__c + '. ' +
                'Please ensure you have copied the correct Id from the Verification Site.'));
            return;
        }
    }
}