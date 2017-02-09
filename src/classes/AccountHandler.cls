public with sharing class AccountHandler {
	public static Account insertNewAccount(String name) {
		Account a = new Account(Name = name);

		try {
			insert a;
			return a;
		} catch(DmlException e) {
			System.debug('ERROR: ' + e.getMessage());
			return null;
		}
	}
}