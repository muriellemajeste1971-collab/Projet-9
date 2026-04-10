public with sharing class AccountAggregator {
    public static void calculateCA(List<Account> accounts, List<Order> orders) {
        List<Account> accountsToUpdate = new List<Account>();   
            for (Account a : accounts) {
                a.Chiffre_d_affaire__c = 0;
                for (Order o : orders) {
                    if (o.Status == 'Activated' && o.AccountId == a.Id && o.TotalAmount != null) {
                        a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + o.TotalAmount;
                    }
                }  
                accountsToUpdate.add(a);
            } 
        update accountsToUpdate;   
    }
}