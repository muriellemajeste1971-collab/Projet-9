public with sharing class OrderTriggerHandler {
    public static void run() {
        if (Trigger.isBefore && Trigger.isUpdate) {
            OrderDomain.validateBeforeUpdate(
                (Map<Id, Order>) Trigger.oldMap, 
                (Map<Id, Order>) Trigger.newMap
            );
        }  
         if (Trigger.isAfter && Trigger.isUpdate) {
            OrderDomain.validateAfterUpdate(
                (Map<Id, Order>) Trigger.oldMap,
                (Map<Id, Order>) Trigger.newMap
            );
        }    
    }
}