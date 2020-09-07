/**
 * @description       : 
 * @author            : Siddharth Pandit
 * @group             : 
 * @last modified on  : 08-31-2020
 * @last modified by  : Siddharth Pandit
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   08-21-2020   Siddharth Pandit   Initial Version
**/
public with sharing class ContactTriggerHandler {
    public class ContactTriggerHandlerException extends Exception {}

    /**
    * @description: Updating accont's shipping address based on the contact's other address
    * @author Siddharth Pandit | 08-21-2020 
    **/
    public static void updateAccountShippingAddress(Map<Id, Contact> conNewMap) {
        if (Utility.isFirstRun) {
            Map<Id, Contact> accIdConMap = new Map<Id, Contact>();
            for (Contact con : conNewMap.values()) {
                if (String.isNotBlank(con.AccountId) &&
                    isOtherAddressNotBlank(con)) {
                    accIdConMap.put(con.AccountId, con);
                } // End if
            } // End for

            List<Account> accListToUpdate = new List<Account>();
            for (Account acct : [SELECT Id, ShippingStreet, ShippingState, ShippingCountry, ShippingPostalCode, ShippingCity
                                    FROM Account
                                    WHERE Id IN : accIdConMap.keySet()]) {
                Contact aCon = accIdConMap.get(acct.Id);
                acct.ShippingStreet = aCon.OtherStreet;
                acct.ShippingState = aCon.OtherState;
                acct.ShippingCity = aCon.OtherCity;
                acct.ShippingPostalCode = aCon.OtherPostalCode;
                acct.ShippingCountry = aCon.OtherCountry;
                accListToUpdate.add(acct);
            }
            Utility.isFirstRun = false; // flip the value to stop recursion
            if (accListToUpdate.size() > 0) {
                update accListToUpdate;
            } // End if
        } // End if
    } // End method


    private static Boolean isOtherAddressNotBlank(Contact aCon) {
        return (String.isNotBlank(aCon.OtherStreet) ||
            String.isNotBlank(aCon.OtherState)||
            String.isNotBlank(aCon.OtherCity)||
            String.isNotBlank(aCon.OtherPostalCode)||
            String.isNotBlank(aCon.OtherCountry));
    }

    public static void updateTotalCount(Map<Id, Contact> newConMap, Map<Id, Contact> oldConMap, Boolean isUpdate) {
        Set<Id> accId = new Set<Id>();
        for (Contact aCon : newConMap.values()) {
            if (aCon.AccountId != null) {
                accId.add(aCon.AccountId);
            }
        }

        Set<Id> prevAcctIdSet = new Set<Id>();
        if (isUpdate) {
            for (Contact aCon : oldConMap.values()) {
                if (aCon.AccountId != null) {
                    prevAcctIdSet.add(aCon.AccountId);
                }
            } // End for
        } // End if
        List<Account> accListToUpdate = new List<Account>();

        try {
            for (Account acct : [SELECT Id, Total_Contacts__c, Type,
                            (SELECT Id FROM Contacts)
                                FROM Account
                                WHERE Id IN : accId
                                OR Id IN: prevAcctIdSet]) {
                if (acct.Type == 'Other') {
                    throw new ContactTriggerHandlerException('You can\'t update Total Contacts if the Account Type is Other');
                }
                acct.Total_Contacts__c = acct.Contacts.size();
                accListToUpdate.add(acct);
            } // End for
    
            if (accListToUpdate.size() > 0) {
                update accListToUpdate;
            }
        } catch (DmlException dmlEx) {
            Error_Log__c log = new Error_Log__c();
            log.Error_Location__c = 'ContactTriggerHandler.updateTotalCount --> DML Exception';
            log.Error_Message__c = dmlEx.getMessage();
            log.Details__c = dmlEx.getStackTraceString();
            insert log;
        } catch (Exception ex) {
            Error_Log__c log = new Error_Log__c();
            log.Error_Location__c = 'ContactTriggerHandler.updateTotalCount';
            log.Error_Message__c = ex.getMessage();
            log.Details__c = ex.getStackTraceString();
            insert log;
        }
    }
}
