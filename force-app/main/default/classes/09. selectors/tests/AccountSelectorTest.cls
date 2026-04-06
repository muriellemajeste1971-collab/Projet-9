
@isTest
private class AccountSelectorTest {

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
            List<Account> results = AccountSelector.selectByIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(1, results.size());
        System.assertEquals(accounts[0].Id, results[0].Id);
        System.assertEquals(300, results[0].Chiffre_d_affaire__c);
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
        // WHEN
        Test.startTest();
            List<Account> results = AccountSelector.selectByIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(200, results.size());
            for (Integer i = 0; i < results.size(); i++) {
                System.assertEquals(accounts[i].Id, results[i].Id);
                System.assertEquals(300, results[i].Chiffre_d_affaire__c);
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
            List<Account> results = AccountSelector.selectByIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(3, results.size());
            for (Integer i = 0; i < results.size(); i++) {
                System.assertEquals(accounts[i].Id, results[i].Id);
                System.assertEquals(300, results[i].Chiffre_d_affaire__c);
            }
    }

    @isTest
    static void test04_negativeBehaviour() {
        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        // WHEN
        Test.startTest();
            List<Account> results = AccountSelector.selectByIds(accountIds);
        Test.stopTest();
        // THEN
        System.assertEquals(0, results.size());
    }
    
    @isTest
    static void test05_restrictedUser() {
        // GIVEN
        List<User> users = TestDataFactory.createUsers(new List<String>{ 'Chatter Free User' });
        insert users;
        User restrictedUser = users[0];
        List<Account> accounts = TestDataFactory.createAccounts(1);
            List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);   
            }
        // WHEN
        Test.startTest();
        System.runAs(restrictedUser) {
              try {
                    AccountSelector.selectByIds(accountIds);
                    System.assert(false, 'Une exception était attendue pour un utilisateur sans accès');
                } catch (Exception e) {
                    System.assertNotEquals(null, e);
                    System.assert(e.getMessage().contains('not supported') || e.getMessage() != null);
                }
            }
        Test.stopTest();
    }
}