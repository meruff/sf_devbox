@isTest
private class TestVerifyDate {

	@isTest static void testCheckDates() {
		// Arrange
		Date d = System.today();
		Date d2 = System.today() + 20;

		// Act
		Date d3 = VerifyDate.CheckDates(d,d2);

		// Assert
		System.assert(d3 == System.today() + 20);
	}

	@isTest static void testCheckDatesOutsideOf30Days() {
		// Arrange
		Date d = System.today();
		Date d2 = System.today() + 40;

		// Act
		Date d3 = VerifyDate.CheckDates(d,d2);

		// Assert
		Integer totalDays = Date.daysInMonth(d.year(), d.month());
		Date lastDay = Date.newInstance(d.year(), d.month(), totalDays);
		System.assert(d3 == lastDay);
	}

	@isTest static void testCheckDatesInsideOf30Days() {
		// Arrange
		Date d = System.today();
		Date d2 = System.today() - 20;

		// Act
		Date d3 = VerifyDate.CheckDates(d,d2);

		// Assert
		Integer totalDays = Date.daysInMonth(d.year(), d.month());
		Date lastDay = Date.newInstance(d.year(), d.month(), totalDays);
		System.assert(d3 == lastDay);
	}
}