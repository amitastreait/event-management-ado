trigger QuoteAcceptedTrigger on Quote (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        QuoteTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}