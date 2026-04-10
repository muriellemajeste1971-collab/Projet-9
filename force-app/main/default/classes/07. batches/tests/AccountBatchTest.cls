@isTest
private class AccountBatchTest {

    @isTest
    static void test00_batch() {
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
            Id batchId = Database.executeBatch(new AccountBatch(), 200);
        Test.stopTest();
        // THEN
        List<Account> results = AccountSelector.selectByIds(accountIds);  
        System.assertNotEquals(0, results[0].Chiffre_d_affaire__c, 'Le batch doit mettre à jour le CA du compte');
    } 
}
