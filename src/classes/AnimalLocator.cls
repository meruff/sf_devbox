/*****************************************
* File: AnimalLocator
* Author: meruff
* Description: Trailhead Class for a HTTP callout to get Animal Names
* used here: https://trailhead.salesforce.com/modules/apex_integration_services/units/apex_integration_rest_callouts
******************************************/
global class AnimalLocator {
    public static String getAnimalNameById(Integer animalId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + animalId);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        Map<String, Object> animal = (Map<String, Object>) results.get('animal');

        return (String) animal.get('name');
    }
}