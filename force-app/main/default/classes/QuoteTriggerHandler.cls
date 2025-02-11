public with sharing class QuoteTriggerHandler {

    public static void handleAfterUpdate(List<Quote> newQuotes, Map<Id, Quote> oldQuoteMap) {
        List<Order> ordersToInsert = new List<Order>();
        Map<Id, Id> quoteToOrderMap = new Map<Id, Id>();

        for (Quote q : newQuotes) {
            Quote oldQuote = oldQuoteMap.get(q.Id);
            // Check if the Quote is accepted and was not accepted before
            if (q.Status == 'Accepted' && oldQuote.Status != 'Accepted') {
                // Create a new Order
                Order newOrder = new Order();
                newOrder.AccountId = q.AccountId;
                newOrder.EffectiveDate = Date.today(); // Set current date as Order Start Date
                newOrder.Status = 'Draft'; // Initial status, adjust as needed
                newOrder.BillingStreet = q.BillingStreet;
                newOrder.BillingCity = q.BillingCity;
                newOrder.BillingState = q.BillingState;
                newOrder.BillingPostalCode = q.BillingPostalCode;
                newOrder.BillingCountry = q.BillingCountry;
                newOrder.ShippingStreet = q.ShippingStreet;
                newOrder.ShippingCity = q.ShippingCity;
                newOrder.ShippingState = q.ShippingState;
                newOrder.ShippingPostalCode = q.ShippingPostalCode;
                newOrder.ShippingCountry = q.ShippingCountry;
                newOrder.Description = q.Description;
                newOrder.CompanyAuthorizedById = UserInfo.getUserId(); // Current user
                newOrder.Pricebook2Id = q.Pricebook2Id;
                newOrder.Opportunity__c = q.OpportunityId;
                newOrder.Quote__c = q.Id;
                ordersToInsert.add(newOrder);
                quoteToOrderMap.put(q.Id, null); // Placeholder for Order Id
            }
        }

        if (!ordersToInsert.isEmpty()) {
            insert ordersToInsert;

            // Update the map with the newly created Order Ids
            Integer index = 0;
            for (Order o : ordersToInsert) {
                quoteToOrderMap.put(newQuotes[index].Id, o.Id);
                index++;
            }

            // Fetch Quote Line Items for the Quotes
            List<QuoteLineItem> quoteLineItems = [SELECT Id, QuoteId, PricebookEntryId, Product2Id, Quantity, UnitPrice
                                                  FROM QuoteLineItem
                                                  WHERE QuoteId IN :quoteToOrderMap.keySet()];

            // Create Order Items
            List<OrderItem> orderItemsToInsert = new List<OrderItem>();
            for (QuoteLineItem qli : quoteLineItems) {
                OrderItem oi = new OrderItem();
                oi.OrderId = quoteToOrderMap.get(qli.QuoteId);
                oi.PricebookEntryId = qli.PricebookEntryId;
                oi.Quantity = qli.Quantity;
                oi.UnitPrice = qli.UnitPrice;
                orderItemsToInsert.add(oi);
            }

            if (!orderItemsToInsert.isEmpty()) {
                insert orderItemsToInsert;
            }
        }
    }
}