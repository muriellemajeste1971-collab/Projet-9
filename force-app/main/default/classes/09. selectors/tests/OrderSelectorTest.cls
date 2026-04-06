
@isTest
private class OrderSelectorTest {

    @isTest
    static void test01_singleAction() {
        /// GIVEN
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
            List<Order> result = OrderSelector.selectByIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(1, result.size());
        System.assertEquals(accounts[0].Id, result[0].AccountId);
        System.assertEquals(300, result[0].TotalAmount);
        System.assertEquals(10, result[0].ShipmentCost__c);
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
        // WHEN
        Test.startTest();
            List<Order> result = OrderSelector.selectByIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(200, result.size());
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(accounts[0].Id, result[i].AccountId);
                System.assertEquals(300, result[i].TotalAmount);
                System.assertEquals(10, result[i].ShipmentCost__c);
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
        // WHEN
        Test.startTest();
            List<Order> result = OrderSelector.selectByIds(orderIds);
        Test.stopTest();
        // THEN
        System.assertEquals(3, result.size());
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(accounts[0].Id, result[i].AccountId);
                System.assertEquals(300, result[i].TotalAmount);
                System.assertEquals(10, result[i].ShipmentCost__c);
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
        List<Order> orders = TestDataFactory.createOrders(0, 0, accountIds);
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        // WHEN
        Test.startTest();
            List<Order> result = OrderSelector.selectByIds(orderIds);
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
            List<Order> result = OrderSelector.selectByIds(orderIds);
            // THEN
            System.assertNotEquals(null, result);
        }
        Test.stopTest();
    }

     @isTest
    static void test11_singleAction() {
        /// GIVEN
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
            List<Order> result = OrderSelector.selectByAccountIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(1, result.size());
        System.assertEquals(accounts[0].Id, result[0].AccountId);
        System.assertEquals(300, result[0].TotalAmount);
        System.assertEquals(10, result[0].ShipmentCost__c);
    }

    @isTest
    static void test12_bulkActions() {
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
        // WHEN
        Test.startTest();
            List<Order> result = OrderSelector.selectByAccountIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(200, result.size());
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(accounts[0].Id, result[i].AccountId);
                System.assertEquals(300, result[i].TotalAmount);
                System.assertEquals(10, result[i].ShipmentCost__c);
            }
    }

    @isTest
    static void test13_positiveBehaviour() {
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
        // WHEN
        Test.startTest();
            List<Order> result = OrderSelector.selectByAccountIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(3, result.size());
            for (Integer i = 0; i < result.size(); i++) {
                System.assertEquals(accounts[0].Id, result[i].AccountId);
                System.assertEquals(300, result[i].TotalAmount);
                System.assertEquals(10, result[i].ShipmentCost__c);
            }
    }

    @isTest
    static void test14_negativeBehaviour() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        List<Order> orders = TestDataFactory.createOrders(0, 0, accountIds);
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        // WHEN
        Test.startTest();
            List<Order> result = OrderSelector.selectByAccountIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(0, result.size());
    }
    
    @isTest
    static void test15_restrictedUser() {
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
            List<Order> result = OrderSelector.selectByAccountIds(accountIds);
            // THEN
            System.assertNotEquals(null, result);
        }
        Test.stopTest();
    }

}