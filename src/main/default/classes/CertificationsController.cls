/*****************************************
* File: CertificationsController
* Author: meruff
* Description: Controller logic for certifications.page
******************************************/
public class CertificationsController {
    public Integer allCertCount { get; set; }
    public Contact newContact { get; set; }
    public List<ContactCertWrapper> ccws { get; set; }

    public CertificationsController() {
        populateContacts();
    }

    public void populateContacts() {
        allCertCount = 0;
        newContact = new Contact();
        ccws = new List<ContactCertWrapper>();

        List<Contact> contacts = new List<Contact>([
            SELECT Name, Certification_Site_Key__c, (
                SELECT Id, Certification_Name__c, Certification_Date__c, Certification_Logo_URL__c
                FROM Salesforce_Certifications__r
                ORDER BY Certification_Name__c ASC
            )
            FROM Contact
            WHERE Show_On_Certification_Site__c = TRUE
            AND Certification_Site_Key__c != NULL
            ORDER BY Name ASC
        ]);

        for (Contact c : contacts) {
            allCertCount += c.Salesforce_Certifications__r.size();
            ccws.add(new ContactCertWrapper(c));
        }
    }

    public void createNewContact() {
        if (String.isBlank(newContact.Certification_Site_Key__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Certification site key is required.'));
            return;
        }

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(PopulateCertifications.CALLOUT_URL + newContact.Certification_Site_Key__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        String body = res.getBody().replaceAll('\\\\n', '').replaceAll('\\\\"', '"').replaceAll('\\:\"\\{', ':{').replaceAll('\\]\\}\"', ']}').replaceAll('\\{\"jsonResponse"\\:\\{  \"data\" \\:', '{"jsonResponse":{"certUser":');

        PopulateCertifications.CertWrapper wrapper =
            (PopulateCertifications.CertWrapper) JSON.deserialize(body, PopulateCertifications.CertWrapper.class);

        if (!wrapper.data.isEmpty()) {
            List<Salesforce_Certification__c> certificationsToUpsert = new List<Salesforce_Certification__c>();
            newContact.FirstName = wrapper.data[0].jsonResponse.certUser[0].Name.split(' ')[0];
            newContact.LastName = wrapper.data[0].jsonResponse.certUser[0].Name.split(' ')[1];
            newContact.Show_On_Certification_Site__c = true;
            upsert newContact Certification_Site_Key__c;

            if (wrapper.data[0].jsonResponse.certUser[0].RelatedCertificationStatus.records != null && !String.isBlank(newContact.Id)) {
                for (PopulateCertifications.Records cert : wrapper.data[0].jsonResponse.certUser[0].RelatedCertificationStatus.records) {
                    certificationsToUpsert.add(new Salesforce_Certification__c(
                        Contact__c = newContact.Id,
                        Certification_Name__c = cert.ExternalCertificationTypeName,
                        Certification_Date__c = cert.CertificationDate,
                        Upsert_Key__c = newContact.Certification_Site_Key__c + cert.ExternalCertificationTypeName
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

        public ContactCertWrapper(Contact theContact) {
            this.c = theContact;
            this.certs = c.Salesforce_Certifications__r;
        }
    }
}