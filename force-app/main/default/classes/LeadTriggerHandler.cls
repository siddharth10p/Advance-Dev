/**
 * @description       : This is a trigger handler class for Lead. All of the methods are static, so they can be called without initialization of the class
 * @author            : Siddharth Pandit
 * @group             : 
 * @last modified on  : 08-24-2020
 * @last modified by  : Siddharth Pandit
 * Modifications Log 
 * Ver   Date         Author             Modification
 * 1.0   08-21-2020   Siddharth Pandit   Initial Version
**/
public with sharing class LeadTriggerHandler {

    /**
    * @description - Handles duplicate check on insert event
    * @author Siddharth Pandit | 08-21-2020 
    **/
    public static void dupEmailCheck_Insert(List<Lead> leadList) {
        Set<String> leadEmailSet = new Set<String> ();
        for (Lead leadInstance : leadList) {
            if (leadInstance.Email != null) {
                leadEmailSet.add(leadInstance.Email);
            }
        }
        Set<String> emailSet = new Set<String>();
        for (Lead leadExist : [SELECT Id, Email
                            FROM Lead
                            WHERE Email IN : leadEmailSet]) {
            emailSet.add(leadExist.Email);
        }

        for (Lead aLead : leadList) {
            if (emailSet.contains(aLead.Email)) { 
                aLead.addError('Duplicate lead!');
            }
        }
    }

    /**
    * @description: Handles duplicate check on update event
    * @author Siddharth Pandit | 08-21-2020 
    * @param leadList 
    **/
    public static void dupEmailCheck_Update(List<Lead> leadList) {
        Set<String> leadEmailSet = new Set<String> ();
        for (Lead leadInstance : leadList) {
            if (leadInstance.Email != null) {
                leadEmailSet.add(leadInstance.Email);
            }
        }

        Map<String, Id> emailMap = new Map<String, Id>();
        System.debug(' leadEmailSet == ' + leadEmailSet);
            for (Lead leadExist : [SELECT Id, Email
                                FROM Lead
                                WHERE Email IN : leadEmailSet]) {
                System.debug(' leadExist == ' + leadExist);
                emailMap.put(leadExist.Email, leadExist.Id);
            }
            for (Lead aLead : leadList) {
                if (emailMap.containsKey(aLead.Email) &&
                    emailMap.get(aLead.Email) != aLead.Id) { 
                    aLead.addError('Duplicate lead!');
                }
            }
        /* } catch (Exception ex) {
            Error_Log__c log = new Error_Log__c();
            log.Error_Location__c = 'LeadTriggerHandler.dupEmailCheck_Update';
            log.Error_Message__c = ex.getMessage();
            log.Details__c = ex.getStackTraceString();
            insert log;
        } */

    }
}