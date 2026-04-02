public with sharing class OpportunityFactory {

    public static List<Opportunity> assemble(Integer numberOfOpportunities, List<Id> accountIds) {

        List<Opportunity> opportunities = new List<Opportunity>();

            for (Id aId : accountIds) {

                for (Integer i = 0; i < numberOfOpportunities; i++) {
            
                    Opportunity o = new Opportunity(
                    Name = 'Opportunity ' + (i+1),
                    AccountId = aId,
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addDays(30),
                    Amount = 10000
                );
                opportunities.add(o);
            }
        }
        return opportunities;
    }
}