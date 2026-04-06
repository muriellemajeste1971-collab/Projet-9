public with sharing class OrderController {
    @AuraEnabled(cacheable=true)
    public static Account getAccountCA(Id  accountId) {
        List <Account> accounts = AccountSelector.selectByIds(new List<Id>{accountId});
           return accounts[0];
    }
}