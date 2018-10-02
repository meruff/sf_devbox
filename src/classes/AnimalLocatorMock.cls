/*****************************************
* File: AnimalLocatorMock
* Author: meruff
* Description: Mock callout class for AnimalLocator.cls
******************************************/
@IsTest
global class AnimalLocatorMock implements HttpCalloutMock {
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        response.setStatusCode(200);
        return response;
    }
}