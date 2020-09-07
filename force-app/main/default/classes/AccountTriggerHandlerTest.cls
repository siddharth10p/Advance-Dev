@isTest
private class AccountTriggerHandlerTest {

    @IsTest
	static void testCreateContactTrigger() {
        // Test data
        Account acc = new Account(Name = 'Acct1', Type='Prospect');
		Test.startTest();
            insert acc;
        Test.stopTest();
        List<Contact> conList = [SELECT FirstName, LastName, AccountId
                                FROM Contact];
        // Assertions
        System.assertEquals(1, conList.size());
        System.assertEquals('Acct1', conList[0].FirstName);
        System.assertEquals('Default User', conList[0].LastName);
        System.assertEquals(acc.Id, conList[0].AccountId);
    }
    
    @IsTest
	static void testUpdateContactAddressTrigger() {
        // Test data
        Account acc = new Account(Name = 'Acct1', ShippingStreet = '786  Poplar Street',  ShippingPostalCode = '60650',
                                ShippingCity = 'Cicero', ShippingState = 'Illinois', ShippingCountry= 'USA');
        insert acc;
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id);
        insert con;
        Contact aCon = [SELECT OtherStreet, OtherState, OtherCountry, OtherPostalCode, OtherCity
                        FROM Contact
                        WHERE Id =: con.Id];
        // Verify the other address is blank
        System.assertEquals(null, aCon.OtherStreet);
        System.assertEquals(null, aCon.OtherState);
        System.assertEquals(null, aCon.OtherCountry);
        System.assertEquals(null, aCon.OtherPostalCode);
        System.assertEquals(null, aCon.OtherCity);

        Test.startTest();
            Utility.isFirstRun = true; // setting to true to let account trigger run
            acc.ShippingPostalCode = '60606';
            update acc;
        Test.stopTest();
        aCon = [SELECT OtherStreet, OtherState, OtherCountry, OtherPostalCode, OtherCity
                    FROM Contact];
        acc = [SELECT ShippingStreet, ShippingState, ShippingCountry, ShippingPostalCode, ShippingCity
                FROM Account];
        // Assertions
        System.assertEquals(acc.ShippingStreet, aCon.OtherStreet);
        System.assertEquals(acc.ShippingState, aCon.OtherState);
        System.assertEquals(acc.ShippingCountry, aCon.OtherCountry);
        System.assertEquals(acc.ShippingPostalCode, aCon.OtherPostalCode);
        System.assertEquals(acc.ShippingCity, aCon.OtherCity);
	}
}
