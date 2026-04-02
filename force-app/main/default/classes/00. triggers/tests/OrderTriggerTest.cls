
@isTest
private class OrderTriggerTest {

    @isTest
    static void test01_singleAction() {

        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
            }
        List<Order> orders = TestDataFactory.createOrders(1, 1, accountIds);
        insert orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id); 
            }
            for (Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            
        Test.startTest();
            update orders;
        Test.stopTest();

        List<Order> updatedOrders = OrderSelector.selectByIds(orderIds);
        System.assertEquals(10, updatedOrders[0].ShipmentCost__c);
        System.assertEquals('Activated', updatedOrders[0].Status);
        System.assertEquals(100, updatedOrders[0].TotalAmount);
        System.assertEquals(90, updatedOrders[0].NetAmount__c);
        System.assertEquals(accounts[0].Id, updatedOrders[0].AccountId);
    }

    @isTest
    static void test02_bulkActions() {
        // TO DO: implement unit test
    }

    @isTest
    static void test03_positiveBehaviour() {
        // TO DO: implement unit test
    }

    @isTest
    static void test04_negativeBehaviour() {
        // TO DO: implement unit test
    }

     @isTest
    static void test05_restrictedUser() {
        // TO DO: implement unit test
    }

    

}