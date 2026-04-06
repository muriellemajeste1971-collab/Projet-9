public with sharing class OrderItemSelector {
   
   public static List<OrderItem> selectByOrderIds(List<Id> orderIds) {
        return [
            SELECT Id, OrderId, Product2Id, Quantity, UnitPrice, TotalPrice, PricebookEntryId
            FROM OrderItem
            WHERE OrderId IN :orderIds
        ];
    }
}