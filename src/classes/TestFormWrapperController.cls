/**
* @author meruff
* @date 10/2/18
*
* Apex Controller logic for TestFormWrapper.page
*/
public class TestFormWrapperController {
    public Contact theContact { get; set; }
    public FormField.StringRef emailAddy { get; set; }
    public FormField.StringRef dependentString { get; set; }

    public List<FormField> formData {
        get {
            if (formData == null) {
                formData = new List<FormField>{
                    new FormField().withLabel('Student Information').withType('HEADER').build(),
                    new FormField().withName('FirstName').build(),
                    new FormField().withName('LastName').build(),
                    new FormField().withName('Email').withLabel('Email Address').hasIcon().build(),
                    new FormField().withName('HomePhone').withLabel('Phone #').hasIcon().build(),
                    new FormField().withName('Birthdate').build(),
                    new FormField().withLabel('Additional Information').withType('HEADER').build(),
                    new FormField().withStringRef(dependentString).withType('PICKLIST').withLabel('Dependent Picklist').withOptions(getLeadOptions()).build(),
                    new FormField().withName('LeadSource').withDependentField(dependentString).renderedIfValue('Web').build(),
                    new FormField().withName('HasOptedOutOfEmail').build(),
                    new FormField().withName('Description').build(),
                    // TODO: Multi-select
                    // new FormField().withName('Certifications__c').build(),
                    new FormField().withName('Funding_Amount__c').withLabel('Funding').build(),
                    new FormField().withStringRef(emailAddy).withLabel('Custom Email Addy').withType('EMAIL').hasIcon().build()
                };

                FormField.populateFieldOptions(theContact, formData);
            }

            return formData;
        }

        set;
    }

    public TestFormWrapperController() {
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