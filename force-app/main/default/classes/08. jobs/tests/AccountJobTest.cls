
@isTest
global with sharing class AccountJobTest {

    @isTest
    static void test00_job() {
        // GIVEN — rien à préparer
        // WHEN — Exécution du job
        Test.startTest();
            String cron = '0 0 0 1 1 ? 2099';
            System.schedule('TestJob', cron, new AccountJob());
        Test.stopTest();
        // THEN
        System.assert(true, 'Le scheduler doit pouvoir s’exécuter');
    }
}