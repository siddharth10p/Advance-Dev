/**
 * @description       : 
 * @author            : Siddharth Pandit
 * @group             : 
 * @last modified on  : 09-04-2020
 * @last modified by  : Siddharth Pandit
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   09-02-2020   Siddharth Pandit   Initial Version
**/
public with sharing class ContactListController {

    @AuraEnabled
    public static List<Contact> getContactList(List<Id> accountIds) {
        // Getting the list of contacts from where Id is in accountIds
        List<Contact> contactList = [SELECT Id, Name, Email, Phone, AccountId
                                    FROM Contact
                                    WHERE AccountId in :accountIds];
        // Returning the contact list
        return contactList;
    }

    @AuraEnabled
    public static void updateContact(Contact con){
        update con;
    }
}
