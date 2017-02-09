@isTest
private class TestRestrictContactByName {

	@isTest static void testInvalidName() {
		// Arrange
		Contact c = new Contact(
			LastName = 'INVALIDNAME'
		);

		// Act
		Test.startTest();
		insert c;
		Test.stopTest();

		// Assert
		List<Contact> contacts = [select Id from Contact];
		System.assert(contacts.size() == 0);
	}
}