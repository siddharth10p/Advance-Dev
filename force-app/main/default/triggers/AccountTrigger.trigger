/**
 * @description: This trigger creates a default contact if the account type is Prospect
**/
trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.insertContact(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountTriggerHandler.updateContactOtherAddress(Trigger.newMap);
    }
}
