/**
 * @description AccountTriggerHandler
 */
public with sharing class AccountTriggerHandler {

    private static final String USER_NAME = 'amitacertifications@gmail.com.learning.dev1-sfp';
    
    private static List<Product2> getRandomProducts() {
        if (Schema.sObjectType.Product2.isAccessible() && 
            Schema.sObjectType.Product2.fields.Id.isAccessible() && 
            Schema.sObjectType.Product2.fields.Name.isAccessible()) {
            return [SELECT Id, Name FROM Product2 LIMIT 3];
        } 
        // Schema.sObjectType.Product2 is not accessible
        return new List<Product2>();
    }

    /**
     * @description assignUser
     * @param records
     */
    public static void assignUser(List<Account> records){
        Id userId = [SELECT Id FROM User WHERE UserName =:USER_NAME WITH SECURITY_ENFORCED]?.Id;
        for(Account acc: records){
            if (Schema.sObjectType.Account.fields.OwnerId.isUpdateable()) {
                acc.OwnerId = userId;
            }
        }
    }

    private static Map<Id, Map<String, Object>> getPricebookEntryMap(Set<Id> productIds) {
        Map<Id, Map<String, Object>> pricebookEntryMap = new Map<Id, Map<String, Object>>();
        
        List<PricebookEntry> pricebookEntries = Schema.sObjectType.PricebookEntry.isAccessible() &&
            Schema.sObjectType.PricebookEntry.fields.Id.isAccessible() &&
            Schema.sObjectType.PricebookEntry.fields.Product2Id.isAccessible() &&
            Schema.sObjectType.PricebookEntry.fields.UnitPrice.isAccessible() ?
            [SELECT Id, Product2Id, UnitPrice 
            FROM PricebookEntry 
            WHERE Product2Id IN :productIds] :
            new List<PricebookEntry>();
        
        for (PricebookEntry pbe : pricebookEntries) {
            Map<String, Object> entryDetails = new Map<String, Object>{
                'PricebookEntryId' => pbe.Id,
                'UnitPrice' => pbe.UnitPrice
            };
            pricebookEntryMap.put(pbe.Product2Id, entryDetails);
        }
        
        return pricebookEntryMap;
    }

    public static void handleAfterInsert(List<Account> newAccounts) {
        List<Opportunity> opportunitiesToCreate = createOpportunities(newAccounts);
        
        if (!opportunitiesToCreate.isEmpty()) {
            if (Schema.sObjectType.Opportunity.isCreateable()) {
                insert opportunitiesToCreate;
                createOpportunityLineItems(opportunitiesToCreate);
            }
        }
    }

    private static List<Opportunity> createOpportunities(List<Account> accounts) {
        List<Opportunity> opportunities = new List<Opportunity>();
        
        for (Account acc : accounts) {
            if (acc.CreateOpportunity__c) {
                opportunities.add(new Opportunity(
                    Name = acc.Name + ' Opportunity',
                    AccountId = acc.Id,
                    CloseDate = Date.today().addDays(30),
                    StageName = 'Prospecting'
                ));
            }
        }
        return opportunities;
    }

    private static void createOpportunityLineItems(List<Opportunity> opportunities) {
        if (!Schema.sObjectType.OpportunityLineItem.isCreateable()) {
            return;
        }
        
        List<Product2> randomProducts = getRandomProducts();
        Set<Id> productIds = new Set<Id>();
        for (Product2 prod : randomProducts) {
            productIds.add(prod.Id);
        }
        
        Map<Id, Map<String, Object>> pricebookEntryMap = getPricebookEntryMap(productIds);
        List<OpportunityLineItem> lineItems = buildLineItems(opportunities, randomProducts, pricebookEntryMap);
        
        if (!lineItems.isEmpty()) {
            if (Schema.sObjectType.OpportunityLineItem.isCreateable() &&
                Schema.sObjectType.OpportunityLineItem.fields.OpportunityId.isCreateable() &&
                Schema.sObjectType.OpportunityLineItem.fields.PricebookEntryId.isCreateable() &&
                Schema.sObjectType.OpportunityLineItem.fields.Quantity.isCreateable() &&
                Schema.sObjectType.OpportunityLineItem.fields.UnitPrice.isCreateable()) {
                insert lineItems;
            }
        }
    }

    private static List<OpportunityLineItem> buildLineItems(List<Opportunity> opportunities, 
        List<Product2> products, Map<Id, Map<String, Object>> pricebookEntryMap) {
        List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        
        for (Opportunity opp : opportunities) {
            for (Product2 prod : products) {
                if (pricebookEntryMap.containsKey(prod.Id)) {
                    Map<String, Object> entryDetails = pricebookEntryMap.get(prod.Id);
                    lineItems.add(new OpportunityLineItem(
                        OpportunityId = opp.Id,
                        PricebookEntryId = (Id)entryDetails.get('PricebookEntryId'),
                        Quantity = 1,
                        UnitPrice = (Decimal)entryDetails.get('UnitPrice')
                    ));
                }
            }
        }
        return lineItems;
    }
}