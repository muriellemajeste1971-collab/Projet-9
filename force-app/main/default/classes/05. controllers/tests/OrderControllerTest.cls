@isTest
private class OrderControllerTest {

    @isTest
    static void testGetAccountCA() {

        // GIVEN
        List<Account> accounts = TestDataFactory.createAccounts(1);
        insert accounts;
        Id accId = accounts[0].Id;

        // WHEN
        Test.startTest();
        Account result = OrderController.getAccountCA(accId);
        Test.stopTest();

        // THEN
        System.assertNotEquals(null, result);
        System.assertEquals(accId, result.Id);
    }
}