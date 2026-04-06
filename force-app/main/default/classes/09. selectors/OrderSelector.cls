public with sharing class OrderSelector {

    public static List<Order> selectByIds(List<Id> orderIds) {
        
        return [
            SELECT Id, AccountId, ContractId, ShippingCountry, Status, TotalAmount, ShipmentCost__c, NetAmount__c
            FROM Order
            WHERE Id IN :orderIds
        ];
    }

    public static List<Order> selectByAccountIds(List<Id> accountIds) {
        
        return [
            SELECT Id, AccountId, ContractId, ShippingCountry, Status, TotalAmount, ShipmentCost__c, NetAmount__c
            FROM Order
            WHERE AccountId IN :accountIds
        ];
    }
}