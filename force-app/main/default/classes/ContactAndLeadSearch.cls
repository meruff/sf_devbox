public with sharing class ContactAndLeadSearch {
	public static List<List<SObject>> searchContactsAndLeads(String searchString) {
		List<List<SObject>> results = new List<List<SObject>>();

		String query = '' +
			'find \'' + String.escapeSingleQuotes(searchString) + '\' ' +
			'in all fields ' +
			'returning Contact, Lead';

		results = Search.query(query);

		return results;
	}
}