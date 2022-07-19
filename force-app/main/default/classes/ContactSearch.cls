public with sharing class ContactSearch {
	public static List<Contact> searchForContacts(String lastName, String zip) {
		List<Contact> contacts = new List<Contact>();

		contacts = [
			select Id, Name
			from Contact
			where LastName = :lastName
			and MailingPostalCode = :zip
		];

		return contacts;
	}
}