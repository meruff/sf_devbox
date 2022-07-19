/**
* @author Mathew Ruff, Sierra-Cedar
* @date 10/2/18
*
* A custom class to hold field information for Forms.
*/
public class FormField {
    public Boolean required { get; set; }
    public Boolean hasIcon { get; set; }
    public String name { get; set; }
    public String label { get; set; }
    public String type { get; set; }
    public String placeholder { get; set; }
    public StringRef dependentField { get; set; }
    public String renderedIfValue { get; set; }
    public IntRef customIntRef { get; set; }
    public StringRef customStringRef { get; set; }
    public List<SelectOption> options { get; set; }

    public FormField required() {
        this.required = true;
        return this;
    }

    public FormField hasIcon() {
        this.hasIcon = true;
        return this;
    }

    public FormField withName(String value) {
        this.name = value;
        return this;
    }

    public FormField withLabel(String value) {
        this.label = value;
        return this;
    }

    public FormField withType(String value) {
        this.type = value;
        return this;
    }

    public FormField withPlaceholder(String holder) {
        this.placeholder = holder;
        return this;
    }

    public FormField withOptions(List<SelectOption> opts) {
        this.options = opts;
        return this;
    }

    public FormField withDependentField(StringRef value) {
        this.dependentField = value;
        return this;
    }

    public FormField renderedIfValue(String value) {
        this.renderedIfValue = value;
        return this;
    }

    public FormField withIntRef(IntRef value) {
        this.customIntRef = value;
        return this;
    }

    public FormField withStringRef(StringRef value) {
        this.customStringRef = value;
        return this;
    }

    public FormField build() {
        if (this.required == null) this.required = false;
        if (this.hasIcon == null) this.hasIcon = false;
        return this;
    }

    /**
     * Populates the remaining field information from describe data.
     *
     * @param obj, the SObject to pull describe values from.
     * @param fieldOptions, the List of FormField data to populate.
     */
    public static void populateFieldOptions(SObject obj, List<FormField> fieldOptions) {
        Map<String, SObjectField> fieldDescribeMap = obj.getSObjectType().getDescribe().fields.getMap();

        for (FormField fieldOption : fieldOptions) {
            if (!String.isBlank(fieldOption.name) && fieldOption.type != 'HEADER') {
                DescribeFieldResult fieldData = fieldDescribeMap.get(fieldOption.name).getDescribe();
                fieldOption.type = String.valueOf(fieldData.getType());

                // Prevent overwriting custom Labels if they're already set.
                if (String.isBlank(fieldOption.label)) {
                    fieldOption.label = fieldData.getLabel();
                }

                // Build custom List of SelectOptions for Multi Picklists
                if (fieldOption.type == 'MULTIPICKLIST') {
                    List<SelectOption> multiOptions = new List<SelectOption>();

                    for (Schema.PicklistEntry val : fieldData.getPicklistValues()) {
                        multiOptions.add(new SelectOption(val.getValue(), val.getLabel()));
                    }

                    fieldOption.options = multiOptions;
                }
            }
        }
    }

    public class IntRef { public Integer value { get; set; } }
    public class StringRef { public String value { get; set; } }
}