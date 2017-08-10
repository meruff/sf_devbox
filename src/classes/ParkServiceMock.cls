/*****************************************
* File: ParkServiceMock
* Author: Mathew Ruff, Sierra-Cedar
* Description: Mock SOAP callout for ParkLocatorTest.cls
******************************************/
@IsTest
global class ParkServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
        // start - specify the response you want to send
        parkService.byCountryResponse response_x = new parkService.byCountryResponse();
        response_x.return_x = new List<String>{'test', 'something', 'else'};
        // end
        response.put('response_x', response_x);
    }
}