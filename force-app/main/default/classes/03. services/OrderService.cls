public with sharing class OrderService {
    public static List<Id> handleBeforeUpdate(Map<Id, Order> oldOrders, Map<Id, Order> newOrders) {
        List<Id> orderIds = new List<Id>();
            for (Id orderId : newOrders.keySet()) {
                Order oldOrder = oldOrders.get(orderId);
                Order newOrder = newOrders.get(orderId);
                if (oldOrder.Status != 'Activated' && newOrder.Status == 'Activated') {
                    orderIds.add(orderId);
                }
            }
        return orderIds;

    }
}