/*****************************************
* File: ParkLocatorTest
* Author: meruff
* Description: Unit Tests for ParkLocator.cls
******************************************/
@isTest
private class ParkLocatorTest {
    @isTest static void testSOAPCallout() {
        // Arrange
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        String country = 'United States';

        // Act
        String[] parkNames = ParkLocator.country(country);

        // Assert
        System.assertEquals(new List<String>{'test', 'something', 'else'}, parkNames);
    }
}