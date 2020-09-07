/**
 * @description       : 
**/
trigger ContactTrigger on Contact (before insert, after insert, before update,
                            after update, before delete, after delete, after undelete) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        ContactTriggerHandler.updateAccountShippingAddress(Trigger.newMap);
        ContactTriggerHandler.updateTotalCount(Trigger.newMap, Trigger.oldMap, Trigger.isUpdate);
    }

} // End trigger