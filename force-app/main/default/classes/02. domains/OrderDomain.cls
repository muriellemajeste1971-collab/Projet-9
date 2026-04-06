public with sharing class OrderDomain {

    public static void validateBeforeUpdate(Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        List<Id> idsToRecalculate = new List<Id>();
        for (Id orderId : newMap.keySet()) {
            Order oldOrder = oldMap.get(orderId);
            Order newOrder = newMap.get(orderId);
            // Si l’order passe en Activated
            if (oldOrder.Status != 'Activated' && newOrder.Status == 'Activated') {
                idsToRecalculate.add(orderId);
            }
        }
            // Si au moins un order doit être recalculé
            if (!idsToRecalculate.isEmpty()) {
                OrderService.handleBeforeUpdate(idsToRecalculate, newMap);
            }
    }

    public static void validateAfterUpdate(Map<Id, Order> oldMap, Map<Id, Order> newMap) {
       Set<Id> accountIds = new Set<Id>();
        for (Id orderId : newMap.keySet()) {

            Order oldOrder = oldMap.get(orderId);
            Order newOrder = newMap.get(orderId);

            Boolean wasActivated = oldOrder.Status == 'Activated';
            Boolean isActivated  = newOrder.Status == 'Activated';
            Boolean justActivated = !wasActivated && isActivated;
            Boolean amountChanged = isActivated && (oldOrder.TotalAmount != newOrder.TotalAmount);

            // Si l'Order commence à compter, arrête de compter, ou change de montant
            if (justActivated || amountChanged) {
                accountIds.add(newOrder.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
            AccountService.handleAfterUpdate(new List<Id>(accountIds));
        }
    }
}   