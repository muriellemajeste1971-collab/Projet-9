    @isTest
    public class TestDataFactory {

        // Create dummy users for Unit Tests
        public static List<User> createUsers(List<String> profileNames) {

            List<Profile> profiles = ProfileFactory.assemble(profileNames); 
            List<User> users = UserFactory.assemble(profiles); 
            return users; 
        }
        
        // Create dummy accounts for unit tests
        public static List<Account> createAccounts(Integer numberOfAcounts ) {
            
            List<Account> accounts = AccountFactory.assemble(numberOfAcounts);
            return accounts;
        }

  

        // Create dummy orders for Unit Tests
        public static List<Order> createOrders(Integer numberOfOrders, Integer numberOfProducts,  List<Id> accountIds) {

            // 1. Standard Pricebook
            Id pbId = Test.getStandardPricebookId();

            // 2. Create Contract Dummy Data Status Draft
            List<Contract> contracts = ContractFactory.assemble(numberOfOrders, accountIds);
            insert contracts;
                for (Contract c : contracts) {
                    c.Status = 'Activated';       
                }
            update contracts;   

            // 3. Create Order Dummy Data Status Draft
            List<Order> orders = OrderFactory.assemble(contracts, pbId);
            insert orders;

            // 4. Création des Products
            List<Product2> products = Product2Factory.assemble(numberOfProducts);
            insert products;  

            // 5. PricebookEntries
            List<PricebookEntry> entries = PricebookEntryFactory.assemble(products, pbId);
            insert entries;

            // 6. OrderItems
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