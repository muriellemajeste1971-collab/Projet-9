
@isTest
private class OrderItemSelectorTest {

    @isTest
    static void test01_singleAction() {
        /// GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        List<Order> orders = TestDataFactory.createOrders(1, 1, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        // WHEN
        Test.startTest();
            List<OrderItem> result = OrderItemSelector.selectByOrderIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(1, result.size());
        System.assertEquals(orders[0].Id, result[0].OrderId);
        System.assertEquals(100, result[0].TotalPrice);
        System.assertNotEquals(null, result[0].Product2Id);
        System.assertNotEquals(null, result[0].PricebookEntryId);
    }

    @isTest
    static void test02_bulkActions() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        List<Order> orders = TestDataFactory.createOrders(1, 200, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        // WHEN
        Test.startTest();
            List<OrderItem> result = OrderItemSelector.selectByOrderIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(200, result.size());
            Decimal total = 0;
            for (OrderItem oi : result) {
                total += (oi.TotalPrice == null ? 0 : oi.TotalPrice);
            }
        System.assertEquals(20000, total);
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(orders[0].Id, result[i].OrderId);
                System.assertEquals(100, result[i].TotalPrice);
                System.assertNotEquals(null, result[i].Product2Id);
                System.assertNotEquals(null, result[i].PricebookEntryId);
            }
    }

    @isTest
    static void test03_positiveBehaviour() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        List<Order> orders = TestDataFactory.createOrders(1, 3, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        // WHEN
        Test.startTest();
            List<OrderItem> result = OrderItemSelector.selectByOrderIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(3, result.size());
            Decimal total = 0;
            for (OrderItem oi : result) {
                total += (oi.TotalPrice == null ? 0 : oi.TotalPrice);
            }
        System.assertEquals(300, total);
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(orders[0].Id, result[i].OrderId);
                System.assertEquals(100, result[i].TotalPrice);
                System.assertNotEquals(null, result[i].Product2Id);
                System.assertNotEquals(null, result[i].PricebookEntryId);
            }
    }

    @isTest
    static void test04_negativeBehaviour() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        List<Order> orders = TestDataFactory.createOrders(1, 0, accountIds);
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        // WHEN
        Test.startTest();
            List<OrderItem> result = OrderItemSelector.selectByOrderIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(0, result.size());
    }
    
    @isTest
    static void test05_restrictedUser() {
        // GIVEN
        List<User> users = TestDataFactory.createUsers(new List<String>{ 'Chatter Free User' });
        insert users;
        User restrictedUser = users[0];
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
                for (Account a : accounts) {
                    accountIds.add(a.Id);   
                }
        List<Order> orders = TestDataFactory.createOrders(1, 1, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
                for (Order o : orders) {
                    orderIds.add(o.Id);     
                }

        // WHEN
        Test.startTest();
        System.runAs(restrictedUser) {
            List<OrderItem> result = OrderItemSelector.selectByOrderIds(orderIds);
            // THEN
            System.assertNotEquals(null, result);
        }
        Test.stopTest();
    }
}