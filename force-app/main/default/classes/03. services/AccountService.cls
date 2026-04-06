public with sharing class AccountService {
    public static void handleAfterUpdate(List<Id> accountIds) {
        List<Account> accounts = AccountSelector.selectByIds(accountIds);
        List<Order> orders = OrderSelector.selectByAccountIds(accountIds);
        AccountAggregator.calculateCA(accounts, orders);
    }
}