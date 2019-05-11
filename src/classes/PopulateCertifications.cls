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
            SELECT Name, Certification_Site_Key__c,
                (
                    SELECT Id, Certification_Name__c, Certification_Date__c, Certification_Logo_URL__c 
                    FROM Salesforce_Certifications__r
                )
            FROM Contact
            WHERE Show_On_Certification_Site__c = TRUE
            AND Certification_Site_Key__c != NULL
        ]);

        if (contacts.size() > 0) {
            for (Contact con : contacts) {
                contactMap.put(con.Name, con);
            }

            calloutToCertSite(contactMap);
        }
    }

    public static void calloutToCertSite(Map<String, Contact> contactMap) {
        List<CertWrapper> wrappers = new List<CertWrapper>();

        for (Contact c : contactMap.values()) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(CALLOUT_URL + c.Certification_Site_Key__c);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            String body = res.getBody().replaceAll('\\\\n', '').replaceAll('\\\\"', '"').replaceAll('\\:\"\\{', ':{').replaceAll('\\]\\}\"', ']}').replaceAll('\\{\"jsonResponse"\\:\\{  \"data\" \\:', '{"jsonResponse":{"certUser":');

            wrappers.add((PopulateCertifications.CertWrapper) JSON.deserialize(body, PopulateCertifications.CertWrapper.class));
        }

        if (!wrappers.isEmpty()) {
            List<Contact> contactsToUpsert = new List<Contact>();
            List<Salesforce_Certification__c> certificationsToUpsert = new List<Salesforce_Certification__c>();

            for (CertWrapper wrapper : wrappers) {
                if (contactMap.containsKey(wrapper.data[0].jsonResponse.certUser[0].Name)) {
                    contactsToUpsert.add(new Contact(
                        Certification_Site_Key__c = contactMap.get(wrapper.data[0].jsonResponse.certUser[0].Name).Certification_Site_Key__c,
                        FirstName = wrapper.data[0].jsonResponse.certUser[0].Name.split(' ')[0],
                        LastName = wrapper.data[0].jsonResponse.certUser[0].Name.split(' ')[1],
                        Show_On_Certification_Site__c = true
                    ));

                    if (wrapper.data[0].jsonResponse.certUser[0].RelatedCertificationStatus.records != null) {
                        for (Records cert : wrapper.data[0].jsonResponse.certUser[0].RelatedCertificationStatus.records) {
                            certificationsToUpsert.add(new Salesforce_Certification__c(
                                Contact__c = contactMap.get(wrapper.data[0].jsonResponse.certUser[0].Name).Id,
                                Certification_Name__c = cert.ExternalCertificationTypeName,
                                Certification_Date__c = cert.CertificationDate,
                                Certification_Logo_URL__c = cert.RelatedCertificationType.Image,
                                Upsert_Key__c = contactMap.get(wrapper.data[0].jsonResponse.certUser[0].Name).Certification_Site_Key__c + cert.ExternalCertificationTypeName
                            ));
                        }
                    }
                }

                if (!contactsToUpsert.isEmpty()) upsert contactsToUpsert Certification_Site_Key__c;
                if (!certificationsToUpsert.isEmpty()) upsert certificationsToUpsert Upsert_Key__c;
            }
        }
    }

    public class CertWrapper {
        public String status { get; set; }
        public String errorMessage { get; set; }
        public Data[] data { get; set; }
    }

    public class Data {
        public JSONResponse jsonResponse { get; set; }
    }

    public class JSONResponse {
        public CertUser[] certUser { get; set; }
    }

    public class CertUser {
        public String Name { get; set; }
        public String City { get; set; }
        public String State { get; set; }
        public String Country { get; set; }
        public RelatedCertificationStatus RelatedCertificationStatus { get; set; }
    }

    public class RelatedCertificationStatus {
        public String totalSize { get; set; }
        public Records[] records { get; set; }
    }

    public class Records {
        public String ExternalCertificationTypeName { get; set; }
        public String CertificationDate { get; set; }
        public RelatedCertificationType RelatedCertificationType { get; set; }
    }

    public class RelatedCertificationType {
        public String Image { get; set; }
    }
}