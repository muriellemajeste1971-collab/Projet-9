public with sharing class OrderFactory {

    public static List<Order> assemble(List<Contract> contracts, Id pbId) {

        List<Order> orders = new List<Order>();

            for (Contract c : contracts) {

                Order o = new Order(
                    Name = 'Order with Contract ' + c.Name,
                    AccountId = c.AccountId,
                    ContractId = c.Id,
                    Pricebook2Id = pbId,
                    Status = 'Draft',
                    TotalAmount__c = 0,
                    ShipmentCost__c = 0,
                    EffectiveDate = Date.today()
                    );
                orders.add(o);
            }

        return orders;
    }
}