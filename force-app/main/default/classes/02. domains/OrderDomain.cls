public with sharing class OrderDomain {
    public static List<Id> validateBeforeUpdate(Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        List<Id> orderIds = new List<Id>();
            for (Id orderId : newMap.keySet()) {
                Order oldOrder = oldMap.get(orderId);
                Order newOrder = newMap.get(orderId);
                if (oldOrder.Status == 'Activated') {
                    // Commande finalisée : on ne recalcule rien - les montants sont figés
                    continue;
                }
                if (oldOrder.Status != 'Activated' && newOrder.Status == 'Activated') {
                    orderIds.add(orderId);
                }
            }
        return orderIds;
    }
}