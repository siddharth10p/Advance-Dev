/**
 * @description       : This is a trigger handler for Account. All the functions are static and don't depend on the object
 * @author            : Siddharth Pandit
 * @group             : 
 * @last modified on  : 08-31-2020
 * @last modified by  : Siddharth Pandit
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   08-21-2020   Siddharth Pandit   Initial Version
**/
public with sharing class AccountTriggerHandler {

    /**
    * @description - Update Account's shipping address on Contact's other address
    * @author Siddharth Pandit | 08-21-2020 
    **/
    public static void updateContactOtherAddress(Map<Id, Account> acctNewMap) {
        if (Utility.isFirstRun) {
            List<Contact> conListToUpdate = new List<Contact>();
            for (Contact con : [SELECT Id, AccountId, OtherStreet, OtherCity, OtherState, OtherPostalCode, OtherCountry
                                    FROM Contact
                                    WHERE AccountId IN : acctNewMap.keySet()]) {
                Account acct = acctNewMap.get(con.AccountId);
                con.OtherStreet = acct.ShippingStreet;
                con.OtherCity = acct.ShippingCity;
                con.OtherState = acct.ShippingState;
                con.OtherPostalCode = acct.ShippingPostalCode;
                con.OtherCountry = acct.ShippingCountry;
                conListToUpdate.add(con);
            }
            Utility.isFirstRun = false;
            if (conListToUpdate.size() > 0) {
                update conListToUpdate;
            } // End if
        } // End if
    } // End method

    public static void insertContact(List<Account> acctList) {
        List<Contact> conListToInsert = new List<Contact>();
        for (Account acct : acctList) {
            System.debug('acct ==> ' + acct);
            if (acct.Type == 'Prospect') {
                Contact con = new Contact();
                con.FirstName = acct.Name;
                con.LastName = 'Default User';
                con.AccountId = acct.Id;
                conListToInsert.add(con);
            }
        } // End for
        if (conListToInsert.size() > 0) {
            insert conListToInsert; // DML
        }
    }
} // End class
