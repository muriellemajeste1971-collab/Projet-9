    @isTest
    public class TestDataFactory {
        public static List<User> createUsers(List<String> profileNames) {
            List<Profile> profiles = ProfileFactory.assemble(profileNames); 
            List<User> users = UserFactory.assemble(profiles); 
            return users; 
        }
        public static List<Account> createAccounts(Integer numberOfAcounts ) {
            List<Account> accounts = AccountFactory.assemble(numberOfAcounts);
            return accounts;
        }
        public static List<Order> createOrders(Integer numberOfOrders, Integer numberOfProducts,  List<Id> accountIds) {
            Id pbId = Test.getStandardPricebookId();
            
            List<Contract> contracts = ContractFactory.assemble(numberOfOrders, accountIds);
            insert contracts;
                for (Contract c : contracts) {
                    c.Status = 'Activated';       
                }
            update contracts;   

            List<Order> orders = OrderFactory.assemble(contracts, pbId);
            insert orders;
                List<Product2> products = Product2Factory.assemble(numberOfProducts);
                insert products;  
                List<PricebookEntry> entries = PricebookEntryFactory.assemble(products, pbId);
                insert entries;
                List<OrderItem> items = OrderItemFactory.assemble(orders, numberOfProducts, entries, products);
                insert items;
                    List<Id> orderIds = new List<Id>();
                        for (Order o : orders) {
                            orderIds.add(o.Id);     
                        }
            orders = OrderSelector.selectByIds(orderIds);
            return orders;
        }		       
    }