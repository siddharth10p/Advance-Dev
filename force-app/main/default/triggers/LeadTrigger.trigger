/**
 * @description       : A trigger to evaluate the email when a new lead is created and stop duplicate emails
**/
trigger LeadTrigger on Lead (before insert, after insert, before update, after update,
                            before delete, after delete, after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        LeadTriggerHandler.dupEmailCheck_Insert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        LeadTriggerHandler.dupEmailCheck_Update(Trigger.new);
    }
}