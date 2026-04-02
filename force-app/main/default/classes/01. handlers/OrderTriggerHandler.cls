public with sharing class OrderTriggerHandler {
    public static void run() {
        if (Trigger.isBefore && Trigger.isUpdate) {
            OrderDomain.validateBeforeUpdate(
                (Map<Id, Order>) Trigger.oldMap, 
                (Map<Id, Order>) Trigger.newMap
            );
            OrderService.handleBeforeUpdate(
                (Map<Id, Order>) Trigger.oldMap,
                (Map<Id, Order>) Trigger.newMap
            );
        }      
    }
}