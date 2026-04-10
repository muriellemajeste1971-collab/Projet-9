global class AccountBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Activated'
        return Database.getQueryLocator([
            SELECT Id, Name, Chiffre_d_affaire__c
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')]);
    }
     
    global void execute(Database.BatchableContext info, List<Account> accounts){
        // Appeler une class qui va faire la logique du code;
        List<Id> accountIds = new List<Id>();
            for (Account a : accounts) {
                accountIds.add(a.Id);
            }
        List<Order> orders = OrderSelector.selectByAccountIds(accountIds);
            AccountAggregator.calculateCA(accounts, orders);   
    }    
     
    global void finish(Database.BatchableContext info){     
        // rien à faire pour ce batch
    } 
 }