global with sharing class AccountJob implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        AccountBatch batchJob = new AccountBatch();
        Id batchId = Database.executeBatch(batchJob, 200);
    }
}
