/**
* @author meruff
* @date 10/2/18
*
* Apex Controller logic for FormExample.page
*/
public class FormExampleController {
    public Contact theContact { get; set; }
    public FormField.StringRef emailAddy { get; set; }
    public FormField.StringRef dependentString { get; set; }

    public List<FormField> formData {
        get {
            if (formData == null) {
                formData = new List<FormField>{
                    new FormField().withLabel('User Information').withType('HEADER').build(),
                    new FormField().withName('FirstName').withPlaceholder('Enter First Name').build(),
                    new FormField().withName('LastName').withPlaceholder('Enter Last Name').build(),
                    new FormField().withName('Email').withPlaceholder('Enter Email Address').build(),
                    new FormField().withName('HomePhone').withPlaceholder('Enter Phone Number').withLabel('Phone #').withPlaceholder('Enter Phone Number').build(),
                    new FormField().withName('Birthdate').build(),
                    new FormField().withLabel('Additional Information').withType('HEADER').build(),
                    new FormField().withName('HasOptedOutOfEmail').build(),
                    new FormField().withName('Certifications__c').build(),
                    new FormField().withName('Funding_Amount__c').withLabel('Funding').withPlaceholder('Enter Funding Amount').build(),
                    new FormField().withStringRef(emailAddy).withLabel('Custom Email Field With Label').withType('EMAIL').withPlaceholder('Custom Email Entry').build()
                };

                FormField.populateFieldOptions(theContact, formData);
            }

            return formData;
        }

        set;
    }

    public List<FormField> dependentLeadLists {
        get {
            if (dependentLeadLists == null) {
                dependentLeadLists = new List<FormField>{
                    new FormField().withLabel('Dependent Picklists').withType('HEADER').build(),
                    new FormField().withStringRef(dependentString).withType('PICKLIST').withLabel('Dependent Picklist').withOptions(getLeadOptions()).build(),
                    new FormField().withName('LeadSource').withDependentField(dependentString).renderedIfValue('Web').build()
                };

                FormField.populateFieldOptions(theContact, dependentLeadLists);
            }

            return dependentLeadLists;
        }

        set;
    }

    public FormExampleController() {
        theContact = new Contact();

        // TODO: IMPORTANT YOU DO THIS
        emailAddy = new FormField.StringRef();
        dependentString = new FormField.StringRef();
    }

    public List<SelectOption> getLeadOptions() {
        return new List<SelectOption>{
            new SelectOption('', '--None--'),
            new SelectOption('Something', 'Something'),
            new SelectOption('Web', 'Web')
        };
    }

    public void saveContact() {
        String test = '';
        for (FormField field : formData) {
            if (!String.isBlank(field.renderedIfValue) && field.renderedIfValue == 'Web' && field.name == 'LeadSource') {
                test = field.dependentField.value;
            }
        }
        System.debug('merf test: ' + test);
        System.debug('merf dependentString: ' + dependentString.value);
        System.debug('merf equals each other?: ' + dependentString.value == test);
        System.debug('merf saving theContact: ' + theContact);
    }
}