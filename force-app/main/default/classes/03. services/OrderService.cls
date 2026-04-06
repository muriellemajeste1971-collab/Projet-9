public with sharing class OrderService {
    public static void handleBeforeUpdate(List<Id> orderIds, Map<Id, Order> newMap) {
        List<Order> orders = new List<Order>();
        for (Id id : orderIds) {
            orders.add(newMap.get(id));
        }
        OrderAggregator.calculateNetAmounts(orders);
    }
}