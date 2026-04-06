
@isTest
private class AccountAggregatorTest {

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
        List<Account> results = AccountSelector.selectByIds(accountIds);  
        List<Order> orderResults = OrderSelector.selectByIds(orderIds);
        // WHEN
        Test.startTest();
            AccountAggregator.calculateCA(results, orderResults);
        Test.stopTest();
        // THEN
        System.assertEquals(1, results.size());
        System.assertEquals(accounts[0].Id, results[0].Id);
        System.assertEquals(orderResults[0].TotalAmount, results[0].Chiffre_d_Affaire__c);
    }

    @isTest
    static void test02_bulkActions() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(200);
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
        List<Account> results = AccountSelector.selectByIds(accountIds);  
        List<Order> orderResults = OrderSelector.selectByIds(orderIds);
        // WHEN
        Test.startTest();
            AccountAggregator.calculateCA(results, orderResults);
        Test.stopTest();
        // THEN
        System.assertEquals(200, results.size());
            for (Integer i = 0; i < results.size(); i++) {
                System.assertEquals(accounts[i].Id, results[i].Id);
                System.assertEquals(orderResults[i].TotalAmount, results[i].Chiffre_d_Affaire__c);
            }        
    }

    @isTest
    static void test03_positiveBehaviour() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(3);
        insert accounts;
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        List<Order> orders = TestDataFactory.createOrders(1, 10, accountIds);
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
                o.Status = 'Activated';
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        List<Account> results = AccountSelector.selectByIds(accountIds);  
        List<Order> orderResults = OrderSelector.selectByIds(orderIds);
        // WHEN
        Test.startTest();
            AccountAggregator.calculateCA(results, orderResults);
        Test.stopTest();
        // THEN
        System.assertEquals(3, results.size());
            for (Integer i = 0; i < results.size(); i++) {
                System.assertEquals(accounts[i].Id, results[i].Id);
                System.assertEquals(orderResults[i].TotalAmount, results[i].Chiffre_d_Affaire__c);
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
            for(Order o : orders) {
                o.ShipmentCost__c = 10;
            }
            update orders;
            List<Id> orderIds = new List<Id>();
            for (Order o : orders) {
                orderIds.add(o.Id);     
            }
        List<Account> results = AccountSelector.selectByIds(accountIds);  
        List<Order> orderResults = OrderSelector.selectByIds(orderIds);
        // WHEN
        Test.startTest();
            AccountAggregator.calculateCA(results, orderResults);
        Test.stopTest();
        // THEN
        System.assertEquals(300, orderResults[0].TotalAmount);
        System.assertEquals(0, results[0].Chiffre_d_Affaire__c);
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
        List<Account> results = AccountSelector.selectByIds(accountIds);  
        List<Order> orderResults = OrderSelector.selectByIds(orderIds);
        // WHEN
        Test.startTest();
        System.runAs(restrictedUser) {
            AccountAggregator.calculateCA(results, orderResults);
            // THEN
            System.assertNotEquals(null, results);
        }
        Test.stopTest();
    }
}