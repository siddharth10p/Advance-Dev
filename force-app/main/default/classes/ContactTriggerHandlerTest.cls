@isTest
private class ContactTriggerHandlerTest {
    @IsTest
	static void testUpdateShippingAddressOnUpdate() {
        // Test data
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acct.Id);
        insert con;

        acct = [SELECT ShippingStreet, ShippingState, ShippingCountry, ShippingPostalCode, ShippingCity
                FROM Account];
        // Verify the shipping address is blank
        System.assertEquals(null, acct.ShippingStreet);
        System.assertEquals(null, acct.ShippingState);
        System.assertEquals(null, acct.ShippingCountry);
        System.assertEquals(null, acct.ShippingPostalCode);
        System.assertEquals(null, acct.ShippingCity);

        con.OtherStreet = '1753  Hood Avenue';
        con.OtherState = 'California';
        con.OtherCountry = 'USA';
        con.OtherPostalCode = '92103';
        con.OtherCity = 'San Diego';
        Utility.isFirstRun = true; // setting to true to let account trigger run
        update con;

        acct = [SELECT ShippingStreet, ShippingState, ShippingCountry, ShippingPostalCode, ShippingCity,
                Total_Contacts__c
                FROM Account];

        con = [SELECT OtherStreet, OtherState, OtherCountry, OtherPostalCode, OtherCity
                FROM Contact];
        // Verify the shipping address is blank
        System.assertEquals(con.OtherStreet, acct.ShippingStreet);
        System.assertEquals(con.OtherState, acct.ShippingState);
        System.assertEquals(con.OtherCountry, acct.ShippingCountry);
        System.assertEquals(con.OtherPostalCode, acct.ShippingPostalCode);
        System.assertEquals(con.OtherCity, acct.ShippingCity);
        System.assertEquals(1, acct.Total_Contacts__c);
    }

    @IsTest
	static void testUpdateShippingAddressOnInsert() {
        // Test data
        Account acct = new Account(Name = 'Test Account');
        insert acct;

        acct = [SELECT ShippingStreet, ShippingState, ShippingCountry, ShippingPostalCode, ShippingCity
                FROM Account];
        // Verify the shipping address is blank
        System.assertEquals(null, acct.ShippingStreet);
        System.assertEquals(null, acct.ShippingState);
        System.assertEquals(null, acct.ShippingCountry);
        System.assertEquals(null, acct.ShippingPostalCode);
        System.assertEquals(null, acct.ShippingCity);

        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acct.Id,
            OtherStreet = '1753  Hood Avenue', OtherState = 'California', OtherCountry = 'USA',
            OtherPostalCode = '92103', OtherCity = 'San Diego');
        insert con;

        acct = [SELECT ShippingStreet, ShippingState, ShippingCountry, ShippingPostalCode, ShippingCity,
                Total_Contacts__c
                FROM Account];

        con = [SELECT OtherStreet, OtherState, OtherCountry, OtherPostalCode, OtherCity
                FROM Contact];
        // Verify the shipping address is blank
        System.assertEquals(con.OtherStreet, acct.ShippingStreet);
        System.assertEquals(con.OtherState, acct.ShippingState);
        System.assertEquals(con.OtherCountry, acct.ShippingCountry);
        System.assertEquals(con.OtherPostalCode, acct.ShippingPostalCode);
        System.assertEquals(con.OtherCity, acct.ShippingCity);
        System.assertEquals(1, acct.Total_Contacts__c);
    }


    @IsTest
	static void testupdateTotalCount_error() {
        // Test data
        Account acct = new Account(Name = 'Test Account', Type = 'Other');
        insert acct;

        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acct.Id);
        insert con;

        List<Error_Log__c> errors = [SELECT Id, Error_Message__c FROM Error_Log__c];
        System.assertEquals(1, errors.size());
        System.assertEquals('You can\'t update Total Contacts if the Account Type is Other', errors[0].Error_Message__c);
    }
}
