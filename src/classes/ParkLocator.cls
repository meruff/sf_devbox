/*****************************************
* File: ParkLocator
* Author: Mathew Ruff, Sierra-Cedar
* Description: Used to return an array of Park Names for Trailhead
* found at: https://trailhead.salesforce.com/modules/apex_integration_services/units/apex_integration_soap_callouts
******************************************/
public class ParkLocator {
    public static String[] country(String countryName) {
        ParkService.ParksImplPort parkNames = new ParkService.ParksImplPort();
        return parkNames.byCountry(countryName);
    }
}