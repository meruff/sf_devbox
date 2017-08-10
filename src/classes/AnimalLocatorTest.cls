/*****************************************
* File: AnimalLocatorTest
* Author: Mathew Ruff, Sierra-Cedar
* Description: Unit Tests for AnimalLocator.cls
******************************************/
@isTest
private class AnimalLocatorTest {
    static testMethod void testCallout() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());

        // Act
        Test.startTest();
        String chickenName = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();

        // Assert
        System.assertEquals('chicken', chickenName);
    }
}