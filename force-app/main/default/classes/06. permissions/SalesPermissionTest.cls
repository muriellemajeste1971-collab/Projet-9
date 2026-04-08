@IsTest
private class SalesPermissionTest {

    @IsTest
    static void test00_permission() {
        //GIVEN
        // 1. Créer un utilisateur Sales
        UserRole r = new UserRole(Name = 'TestRole');
        insert r;
        List<User> users = TestDataFactory.createUsers(new List<String>{ 'Sales' });
        insert users;
        User u = users[0];
        

        // 2. Récupérer la permission set créée dans Setup
        PermissionSet ps = [
            SELECT Id FROM PermissionSet WHERE Name = 'OrderManager' LIMIT 1
        ];

        // 3. Assigner la permission à l’utilisateur
        insert new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );

        // 4. Tester le comportement sous cet utilisateur
        System.runAs(u) {
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
    }
}