public with sharing class AccountTriggerHandler {
    public static void run() {
        if (Trigger.isAfter && Trigger.isUpdate) {
            AccountService.handleAfterUpdate(
                (Map<Id, Account>) Trigger.oldMap,
                (Map<Id, Account>) Trigger.newMap
            );
        }
    }
}