@isTest
public with sharing class QuoteAcceptedTriggerTest {
    
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

        // Create an Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            AccountId = acc.Id,
            Pricebook2Id = standardPricebookId
        );
        insert opp;
        
        // Create Quotes
        List<Quote> quotes = new List<Quote>();
        for (Integer i = 0; i < 5; i++) {
            Quote q = new Quote(
                Name = 'Test Quote ' + i,
                OpportunityId = opp.Id,
                Status = 'Draft',
                Pricebook2Id = standardPricebookId
            );
            quotes.add(q);
        }
        insert quotes;
        
        // Create QuoteLineItems
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        for (Quote q : quotes) {
            QuoteLineItem qli = new QuoteLineItem(
                QuoteId = q.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = 100
            );
            quoteLineItems.add(qli);
        }
        insert quoteLineItems;
    }
    
    @isTest
    static void testQuoteAccepted() {
        // Fetch Quotes
        List<Quote> quotes = [SELECT Id, Status FROM Quote];
        
        // Update Quotes to Accepted
        for (Quote q : quotes) {
            q.Status = 'Accepted';
        }
        update quotes;
        
        // Verify Orders and OrderItems
        List<Order> orders = [SELECT Id, AccountId FROM Order];
        System.assertEquals(5, orders.size(), 'Five orders should be created.');
        
        List<OrderItem> orderItems = [SELECT Id, OrderId FROM OrderItem];
        System.assertEquals(5, orderItems.size(), 'Five order items should be created.');
    }
    
    @isTest
    static void testQuoteNotAccepted() {
        // Fetch Quotes
        List<Quote> quotes = [SELECT Id, Status FROM Quote];
        
        // Update Quotes to a non-accepted status
        for (Quote q : quotes) {
            q.Status = 'Draft';
        }
        update quotes;
        
        // Verify no Orders are created
        List<Order> orders = [SELECT Id FROM Order];
        System.assertEquals(0, orders.size(), 'No orders should be created.');
    }
    
    @isTest
    static void testAlreadyAcceptedQuote() {
        // Fetch Quotes
        List<Quote> quotes = [SELECT Id, Status FROM Quote];
        
        // Update Quotes to Accepted
        for (Quote q : quotes) {
            q.Status = 'Accepted';
        }
        update quotes;
        
        // Verify Orders and OrderItems
        List<Order> orders = [SELECT Id, AccountId FROM Order];
        System.assertEquals(5, orders.size(), 'Five orders should be created.');
        
        List<OrderItem> orderItems = [SELECT Id, OrderId FROM OrderItem];
        System.assertEquals(5, orderItems.size(), 'Five order items should be created.');
    }
}