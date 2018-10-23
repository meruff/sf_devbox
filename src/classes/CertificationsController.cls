/*****************************************
* File: CertificationsController
* Author: meruff
* Description: Controller logic for certifications.page
******************************************/
public class CertificationsController {
    public Integer sciCertCount { get; set; }
    public Contact newContact { get; set; }
    public List<ContactCertWrapper> ccws { get; set; }

    public final Decimal PARTNER_CERT_COUNT {
        get {
            if (PARTNER_CERT_COUNT == null) {
                PARTNER_CERT_COUNT = 25;
            }

            return PARTNER_CERT_COUNT;
        }

        set;
    }

    public static final Set<String> NON_VALID_CERTS {
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

    public static final Set<String> VALID_CERTS {
        get {
            if (VALID_CERTS == null) {
                VALID_CERTS = new Set<String>{
                    'Salesforce Certified Sales Cloud Consultant',
                    'Salesforce Certified Service Cloud Consultant',
                    'Salesforce Certified Platform Developer I',
                    'Salesforce Certified Community Cloud Consultant',
                    'Salesforce Certified Marketing Cloud Consultant',
                    'Salesforce Certified Pardot Specialist',
                    'Salesforce Certified Commerce Cloud Digital Developer',
                    'Salesforce Certified Platform App Builder',
                    'Salesforce Certified Advanced Administrator',
                    'Salesforce Certified Platform Developer II',
                    'Salesforce Certified Development Lifecycle & Deployment Designer',
                    'Salesforce Certified Integration Architecture Designer',
                    'Salesforce Certified Data Architecture & Management Designer',
                    'Salesforce Certified Commerce Cloud Technical Solution Designer',
                    'Salesforce Certified Sharing & Visibility Designer',
                    'Salesforce Certified Mobile Solutions Architecture Designer',
                    'Salesforce Certified Identity and Access Management Designer',
                    'Salesforce Certified Marketing Cloud Social Specialist',
                    'Salesforce Certified Field Services Lightning Consultant',
                    'Salesforce Certified CPQ Specialist',
                    'Salesforce Certified Technical Architect',
                    'Salesforce Certified Application Architect',
                    'Salesforce Certified System Architect'
                };
            }

            return VALID_CERTS;
        }

        set;
    }

    public CertificationsController() {
        populateContacts();
    }

    public void populateContacts() {
        sciCertCount = 0;
        newContact = new Contact();
        ccws = new List<ContactCertWrapper>();

        List<Contact> contacts = new List<Contact>([
            SELECT Name, Certification_Contact_Id__c, (
                SELECT Id, Certification_Name__c, Certification_Date__c, Certification_Logo_URL__c
                FROM Salesforce_Certifications__r
                ORDER BY Certification_Name__c ASC
            )
            FROM Contact
            WHERE Show_On_Certification_Site__c = TRUE
            ORDER BY Name ASC
        ]);

        for (Contact c : contacts) {
            Integer validCerts = 0;
            Integer invalidCerts = 0;

            for (Salesforce_Certification__c sc : c.Salesforce_Certifications__r) {
                if (VALID_CERTS.contains(sc.Certification_Name__c)) {
                    sciCertCount++;
                    validCerts++;
                } else {
                    invalidCerts++;
                }
            }

            ContactCertWrapper ccw = new ContactCertWrapper();
            ccw.c = c;
            ccw.certs.addAll(c.Salesforce_Certifications__r);
            ccw.validCertCount = validCerts;
            ccw.invalidCertCount = invalidCerts;
            ccws.add(ccw);
        }
    }

    public void createNewContact() {
        if (String.isBlank(newContact.Certification_Contact_Id__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Certification Contact Id is required.'));
            return;
        }

        if (newContact.Certification_Contact_Id__c.length() > 18 || newContact.Certification_Contact_Id__c.length() < 18) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Certification Contact Ids must be 18 characters in length.'));
            return;
        }

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(PopulateCertifications.CALLOUT_URL + newContact.Certification_Contact_Id__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        String body = res.getBody().replaceAll('Full_Name__c', 'fullName');
        body = body.replaceAll('Certification_Status__r', 'CertStatus');
        body = body.replaceAll('External_Certification_Type_Name__c', 'certName');
        body = body.replaceAll('External_Original_Certification_Date__c', 'certDate');

        PopulateCertifications.CertWrapper wrapper =
            (PopulateCertifications.CertWrapper) JSON.deserialize(body, PopulateCertifications.CertWrapper.class);

        if (!wrapper.data.isEmpty()) {
            List<Salesforce_Certification__c> certificationsToUpsert = new List<Salesforce_Certification__c>();
            newContact.FirstName = wrapper.data[0].fullName.split(' ')[0];
            newContact.LastName = wrapper.data[0].fullName.split(' ')[1];
            newContact.Show_On_Certification_Site__c = true;
            upsert newContact Certification_Contact_Id__c;

            if (wrapper.data[0].certStatus != null && !String.isBlank(newContact.Id)) {
                for (PopulateCertifications.Cert cert : wrapper.data[0].certStatus.records) {
                    certificationsToUpsert.add(new Salesforce_Certification__c(
                        Contact__c = newContact.Id,
                        Certification_Name__c = cert.certName,
                        Certification_Date__c = cert.certDate,
                        Upsert_Key__c = newContact.Id + cert.certName
                    ));
                }
            }

            if (!certificationsToUpsert.isEmpty()) {
                upsert certificationsToUpsert Upsert_Key__c;
                populateContacts();
            }
        }
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