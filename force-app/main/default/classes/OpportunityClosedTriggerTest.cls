@isTest
public class OpportunityClosedTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Create a Pricebook
        Id standardPricebookId = Test.getStandardPricebookId();
        
        // Create a Product
        Product2 product = new Product2(Name = 'Test Product', IsActive = true);
        insert product;
        
        // Create a PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;
        
        // Create an Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create Opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Test Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                AccountId = acc.Id,
                Pricebook2Id = standardPricebookId
            );
            opportunities.add(opp);
        }
        insert opportunities;
        
        // Create OpportunityLineItems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for (Opportunity opp : opportunities) {
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opp.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = 100
            );
            oppLineItems.add(oli);
        }
        insert oppLineItems;
    }
    
    @isTest
    static void testOpportunityClosedWon() {
        // Fetch Opportunities
        List<Opportunity> opportunities = [SELECT Id, StageName, IsClosed FROM Opportunity];
        
        // Update Opportunities to Closed Won
        for (Opportunity opp : opportunities) {
            opp.StageName = 'Closed Won';
        }
        update opportunities;
        
        // Verify Quotes and QuoteLineItems
        List<Quote> quotes = [SELECT Id, OpportunityId FROM Quote];
        System.assertEquals(5, quotes.size(), 'Five quotes should be created.');
        
        List<QuoteLineItem> quoteLineItems = [SELECT Id, QuoteId FROM QuoteLineItem];
        System.assertEquals(5, quoteLineItems.size(), 'Five quote line items should be created.');
    }
    
    @isTest
    static void testOpportunityNotClosed() {
        // Fetch Opportunities
        List<Opportunity> opportunities = [SELECT Id, StageName, IsClosed FROM Opportunity];
        
        // Update Opportunities to a non-closed stage
        for (Opportunity opp : opportunities) {
            opp.StageName = 'Negotiation/Review';
        }
        update opportunities;
        
        // Verify no Quotes are created
        List<Quote> quotes = [SELECT Id FROM Quote];
        System.assertEquals(0, quotes.size(), 'No quotes should be created.');
    }
    
    @isTest
    static void testAlreadyClosedOpportunity() {
        // Fetch Opportunities
        List<Opportunity> opportunities = [SELECT Id, StageName, IsClosed FROM Opportunity];
        
        // Update Opportunities to Closed Won
        for (Opportunity opp : opportunities) {
            opp.StageName = 'Closed Won';
        }
        update opportunities;
        
        // Verify Quotes and QuoteLineItems
        List<Quote> quotes = [SELECT Id, OpportunityId FROM Quote];
        System.assertEquals(5, quotes.size(), 'Five quotes should be created.');
        
        List<QuoteLineItem> quoteLineItems = [SELECT Id, QuoteId FROM QuoteLineItem];
        System.assertEquals(5, quoteLineItems.size(), 'Five quote line items should be created.');
    }
}