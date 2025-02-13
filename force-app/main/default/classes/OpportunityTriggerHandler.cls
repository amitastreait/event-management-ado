public with sharing class OpportunityTriggerHandler {
    public static void handleAfterUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldOpportunityMap) {
        List<Quote> quotesToInsert = new List<Quote>();
        List<QuoteLineItem> quoteLineItemsToInsert = new List<QuoteLineItem>();

        for (Opportunity opp : newOpportunities) {
            Opportunity oldOpp = oldOpportunityMap.get(opp.Id);
            // Check if the Opportunity is closed and won, and was not closed before
            if (opp.StageName == 'Closed Won' && opp.IsClosed && !oldOpp.IsClosed) {
                // Create a new Quote
                Quote newQuote = new Quote();
                newQuote.OpportunityId = opp.Id;
                newQuote.Name = opp.Name + ' Quote';
                newQuote.Status = 'Draft'; // Set initial status
                newQuote.Pricebook2Id = opp.Pricebook2Id;
                newQuote.Description = opp.Description;
                quotesToInsert.add(newQuote);
            }
        }

        if (!quotesToInsert.isEmpty()) {
            insert quotesToInsert;

            // Fetch Opportunity Products for the Opportunities
            List<OpportunityLineItem> oppLineItems = [SELECT Id, OpportunityId, PricebookEntryId, Product2Id, Quantity, UnitPrice
                                                      FROM OpportunityLineItem
                                                      WHERE OpportunityId IN :newOpportunities];

            // Map to store OpportunityId to QuoteId
            Map<Id, Id> oppIdToQuoteIdMap = new Map<Id, Id>();
            for (Quote q : quotesToInsert) {
                oppIdToQuoteIdMap.put(q.OpportunityId, q.Id);
            }

            // Create Quote Line Items
            for (OpportunityLineItem oli : oppLineItems) {
                QuoteLineItem qli = new QuoteLineItem();
                qli.QuoteId = oppIdToQuoteIdMap.get(oli.OpportunityId);
                qli.Product2Id = oli.Product2Id;
                qli.Quantity = oli.Quantity;
                qli.UnitPrice = oli.UnitPrice;
                qli.PricebookEntryId = oli.PricebookEntryId;
                quoteLineItemsToInsert.add(qli);
            }

            if (!quoteLineItemsToInsert.isEmpty()) {
                insert quoteLineItemsToInsert;
            }
            
            /* List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
            for (Opportunity opp : newOpportunities) {
                if (oppIdToQuoteIdMap.containsKey(opp.Id)) {
                    Opportunity oppToUpdate = new Opportunity(Id = opp.Id);
                    oppToUpdate.SyncedQuoteId = oppIdToQuoteIdMap.get(opp.Id);
                    opportunitiesToUpdate.add(oppToUpdate);
                }
            }
            update opportunitiesToUpdate; */
        }
    }
}