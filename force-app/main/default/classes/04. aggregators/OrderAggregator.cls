public with sharing class OrderAggregator {
    public static void calculateNetAmounts(List<Order> orders) {
        for (Order o : orders) {
            if (o.TotalAmount != null && o.ShipmentCost__c != null) {
                o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c;
            } else {
                o.NetAmount__c = 0;
            }
        }
    }
}
