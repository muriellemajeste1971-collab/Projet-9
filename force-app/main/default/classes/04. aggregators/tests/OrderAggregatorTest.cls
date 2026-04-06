
@isTest
private class OrderAggregatorTest {

   @isTest
    static void test01_singleAction() {
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
        List<Order> results = OrderSelector.selectByIds(orderIds);  
        // WHEN
        Test.startTest();
            OrderAggregator.calculateNetAmounts(results);
        Test.stopTest();
        // THEN
        System.assertEquals(1, results.size());
        System.assertEquals(accounts[0].Id, results[0].AccountId);
        System.assertEquals(300, results[0].TotalAmount);
        System.assertEquals(10, results[0].ShipmentCost__c);
        System.assertEquals(290, results[0].NetAmount__c);
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
        List<Order> orders = TestDataFactory.createOrders(200, 3, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        List<Order> results = OrderSelector.selectByIds(orderIds);  
        // WHEN
        Test.startTest();
            OrderAggregator.calculateNetAmounts(results);
        Test.stopTest();
        // THEN
        System.assertEquals(200, results.size());
        for (Integer i = 0; i < results.size(); i++) {
            System.assertEquals(accounts[0].Id, results[i].AccountId);
            System.assertEquals(300, results[i].TotalAmount);
            System.assertEquals(10, results[i].ShipmentCost__c);
            System.assertEquals(290, results[i].NetAmount__c);
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
        List<Order> orders = TestDataFactory.createOrders(3, 3, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        List<Order> results = OrderSelector.selectByIds(orderIds);  
        // WHEN
        Test.startTest();
            OrderAggregator.calculateNetAmounts(results);
        Test.stopTest();
        // THEN
        System.assertEquals(3, results.size());
        for (Integer i = 0; i < results.size(); i++) {
            System.assertEquals(accounts[0].Id, results[i].AccountId);
            System.assertEquals(300, results[i].TotalAmount);
            System.assertEquals(10, results[i].ShipmentCost__c);
            System.assertEquals(290, results[i].NetAmount__c);
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
        Order o = new Order(
                AccountId = accounts[0].Id,
                EffectiveDate = Date.today(),
                Status = 'Draft'
            );
        insert o;
        // WHEN
        Test.startTest();
            OrderAggregator.calculateNetAmounts(new List<Order>{ o });
        Test.stopTest();
        // THEN
        // TotalAmount is NULL because no OrderItems
        System.assertEquals(null, o.TotalAmount);
        // NetAmount__c must NOT be calculated
        System.assertEquals(0, o.NetAmount__c);
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
        List<Order> results = OrderSelector.selectByIds(orderIds);
        // WHEN
        Test.startTest();
        System.runAs(restrictedUser) {
            OrderAggregator.calculateNetAmounts(results);
            // THEN
            System.assertNotEquals(null, results);
        }
        Test.stopTest();
    }
}
