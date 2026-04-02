public with sharing class AccountSelector {

    public static List<Account> selectByIds(List<Id> accountIds) {
        // Return early on null/empty to avoid unnecessary SOQL
      
        return [
            SELECT Id, Name, Type, Chiffre_d_affaire__c
            FROM Account
            WHERE Id IN : accountIds
            WITH USER_MODE
        ];
    }
}
