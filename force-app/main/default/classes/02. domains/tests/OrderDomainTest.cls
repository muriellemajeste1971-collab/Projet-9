
@isTest
private class OrderDomainTest {

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
        Map<Id, Order> oldMap = new Map<Id, Order>();
        Map<Id, Order> newMap = new Map<Id, Order>();    
            for (Order o : orders) {
                Order oldO = o.clone(false, true, false, false);
                    oldO.shipmentCost__c = 10;
                    oldO.Status = 'Draft';
                Order newO = o.clone(false, true, false, false);
                    newO.Status = 'Activated';
                    newO.ShipmentCost__c = 10;
                    oldMap.put(o.Id, oldO);
                    newMap.put(o.Id, newO);
            }

        // WHEN
        Test.startTest();
            OrderDomain.validateBeforeUpdate(oldMap, newMap);   
        Test.stopTest();
        // THEN
        List<Id> orderIds = new List<Id>();
            for (Id key : newMap.keySet()) {
                orderIds.add(key);
            }
        Order result = newMap.get(orderIds[0]);
        // Ensure we retrieved a single Order record
        System.assertNotEquals(null, result, 'Expected a non-null Order from newMap');
        System.assertEquals(accounts[0].Id, result.AccountId);
        System.assertEquals(10, result.ShipmentCost__c);
        System.assertEquals(300, result.TotalAmount);
        System.assertEquals(290, result.NetAmount__c);
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
        Map<Id, Order> oldMap = new Map<Id, Order>();
        Map<Id, Order> newMap = new Map<Id, Order>();    

            for (Order o : orders) {

                Order oldO = o.clone(false, true, false, false);
                oldO.Status = 'Draft';
                oldO.ShipmentCost__c = 10;

                Order newO = o.clone(false, true, false, false);
                newO.Status = 'Activated';
                newO.ShipmentCost__c = 10;

                oldMap.put(o.Id, oldO);
                newMap.put(o.Id, newO);
            }
        // WHEN
        Test.startTest();
            OrderDomain.validateBeforeUpdate(oldMap, newMap);   
        Test.stopTest();

        // THEN
        System.assertEquals(200, newMap.size());
            for (Order result : newMap.values()) {
                System.assertNotEquals(null, result);
                System.assertEquals(10, result.ShipmentCost__c);
                System.assertEquals(300, result.TotalAmount);
                System.assertEquals(290, result.NetAmount__c);
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
        Map<Id, Order> oldMap = new Map<Id, Order>();
        Map<Id, Order> newMap = new Map<Id, Order>();    

            for (Order o : orders) {

                Order oldO = o.clone(false, true, false, false);
                oldO.Status = 'Draft';
                oldO.ShipmentCost__c = 10;

                Order newO = o.clone(false, true, false, false);
                newO.Status = 'Activated';
                newO.ShipmentCost__c = 10;

                oldMap.put(o.Id, oldO);
                newMap.put(o.Id, newO);
            }
        // WHEN
        Test.startTest();
            OrderDomain.validateBeforeUpdate(oldMap, newMap);   
        Test.stopTest();

        // THEN
        System.assertEquals(3, newMap.size());
            for (Order result : newMap.values()) {
                System.assertNotEquals(null, result);
                System.assertEquals(10, result.ShipmentCost__c);
                System.assertEquals(300, result.TotalAmount);
                System.assertEquals(290, result.NetAmount__c);
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

        List<Order> orders = TestDataFactory.createOrders(1, 3, accountIds);
        Map<Id, Order> oldMap = new Map<Id, Order>();
        Map<Id, Order> newMap = new Map<Id, Order>();    

            for (Order o : orders) {

                Order oldO = o.clone(false, true, false, false);
                oldO.Status = 'Draft';
                oldO.ShipmentCost__c = 10;

                Order newO = o.clone(false, true, false, false);
                newO.Status = 'Draft';
                newO.ShipmentCost__c = 10;

                oldMap.put(o.Id, oldO);
                newMap.put(o.Id, newO);
            }
        // WHEN
        Test.startTest();
            OrderDomain.validateBeforeUpdate(oldMap, newMap);   
        Test.stopTest();

        // THEN
        System.assertEquals(1, newMap.size());
            for (Order result : newMap.values()) {
                System.assertEquals(null, result.NetAmount__c);
            }
    }
    
    @isTest
    static void test05_restrictedUser_beforeUpdate() {
        // GIVEN
        List<User> users = TestDataFactory.createUsers(new List<String>{ 'Chatter Free User' });
        insert users;
        User restrictedUser = users[0];
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }   
        List<Order> orders = TestDataFactory.createOrders(1, 3, accountIds);
        Map<Id, Order> oldMap = new Map<Id, Order>();
        Map<Id, Order> newMap = new Map<Id, Order>();    
            for (Order o : orders) {
                Order oldO = o.clone(false, true, false, false);
                    oldO.shipmentCost__c = 10;
                    oldO.Status = 'Draft';
                Order newO = o.clone(false, true, false, false);
                    newO.Status = 'Activated';
                    newO.ShipmentCost__c = 10;
                    oldMap.put(o.Id, oldO);
                    newMap.put(o.Id, newO);
            }
        List<Order> results = OrderSelector.selectByAccountIds(accountIds);
        // WHEN
        Test.startTest();
        System.runAs(restrictedUser) {
            OrderDomain.validateBeforeUpdate(oldMap, newMap);  
            // THEN
            System.assertNotEquals(null, results);
        }
        Test.stopTest();
    }
}