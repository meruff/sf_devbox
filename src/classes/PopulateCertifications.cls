/*****************************************
* File: PopulateCertifications
* Author: meruff
* Description: Class to callout to the Salesforce Certificatoin Site and populate Salesforce_Certifications__c
******************************************/
global class PopulateCertifications implements Schedulable {
    public static final String CALLOUT_URL = 'https://certification.secure.force.com/certificationsite/services/apexrest/credential?searchString=';

    global void execute(SchedulableContext SC) {
        findCertifications();
    }

    public PopulateCertifications() {
        findCertifications();
    }

    @Future(Callout=true)
    public static void findCertifications() {
        Map<String, Contact> contactMap = new Map<String, Contact>();

        List<Contact> contacts = new List<Contact>([
            SELECT Name, Certification_Contact_Id__c,
                (
                    SELECT Id, Certification_Name__c, Certification_Date__c, Certification_Logo_URL__c 
                    FROM Salesforce_Certifications__r
                )
            FROM Contact
            WHERE Show_On_Certification_Site__c = TRUE
        ]);

        if (contacts.size() > 0) {
            for (Contact con : contacts) {
                contactMap.put(con.Certification_Contact_Id__c, con);
            }

            calloutToCertSite(contactMap);
        }
    }

    public static void calloutToCertSite(Map<String, Contact> contactMap) {
        List<CertWrapper> wrappers = new List<CertWrapper>();

        for (String salesforceContactId : contactMap.keySet()) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CALLOUT_URL + salesforceContactId);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            String body = res.getBody().replaceAll('Full_Name__c', 'fullName');
            body = body.replaceAll('Certification_Status__r', 'CertStatus');
            body = body.replaceAll('External_Certification_Type_Name__c', 'certName');
            body = body.replaceAll('External_Original_Certification_Date__c', 'certDate');

            wrappers.add((PopulateCertifications.CertWrapper) JSON.deserialize(body, PopulateCertifications.CertWrapper.class));
        }

        if (!wrappers.isEmpty()) {
            List<Contact> contactsToUpsert = new List<Contact>();
            List<Salesforce_Certification__c> certificationsToUpsert = new List<Salesforce_Certification__c>();

            for (CertWrapper wrapper : wrappers) {
                // TODO: Fix Name parsing.
                contactsToUpsert.add(new Contact(
                    Certification_Contact_Id__c = wrapper.data[0].Id,
                    FirstName = wrapper.data[0].fullName.split(' ')[0],
                    LastName = wrapper.data[0].fullName.split(' ')[1],
                    Show_On_Certification_Site__c = true
                ));

                System.debug('merf: ' + wrapper);
                if (wrapper.data[0].certStatus != null && contactMap.containsKey(wrapper.data[0].Id)) {
                    for (Cert cert : wrapper.data[0].certStatus.records) {
                        certificationsToUpsert.add(new Salesforce_Certification__c(
                            Contact__c = contactMap.get(wrapper.data[0].Id).Id,
                            Certification_Name__c = cert.certName,
                            Certification_Date__c = cert.certDate,
                            Upsert_Key__c = contactMap.get(wrapper.data[0].Id).Id + cert.certName
                        ));
                    }
                }
            }

            if (!contactsToUpsert.isEmpty()) upsert contactsToUpsert Certification_Contact_Id__c;
            if (!certificationsToUpsert.isEmpty()) upsert certificationsToUpsert Upsert_Key__c;
        }
    }

    public class CertWrapper {
        public String status { get; set; }
        public Data[] data { get; set; }
    }

    public class Data {
        public String fullName { get; set; }
        public String Id { get; set; }
        public CertStatus certStatus { get; set; }
    }

    public class CertStatus {
        public Integer totalSize { get; set; }
        public Cert[] records { get; set; }
    }

    public class Cert {
        public String certName { get; set; }
        public String certDate { get; set; }
    }
}