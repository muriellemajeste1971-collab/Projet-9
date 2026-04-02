public with sharing class AccountService {
    public static List<Id> handleAfterUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        List<Id> accountIds = new List<Id>();
            for (Id accountId : newMap.keySet()) {
                Account oldAccount = oldMap.get(accountId);
                Account newAccount = newMap.get(accountId);
                if (oldAccount.Chiffre_d_affaire__c != newAccount.Chiffre_d_affaire__c) {
                    accountIds.add(accountId);
                }
            }
        return accountIds;
    }
}