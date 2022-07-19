public with sharing class StringArrayTest {
	public static List<String> generateStringArray(Integer num) {
		List<String> strings = new List<String>();

		for (Integer i = 0; i < num; i++) {
			String str = 'Test ' + i;
			strings.add(str);
		}

		return strings;
	}
}