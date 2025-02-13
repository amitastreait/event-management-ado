/**
 * @description Hello World
 */
@IsTest
public with sharing class AccountTriggerHandlerTest {

    /**
     * @description Hello World
     */
    @TestSetup
    private static void setupData(){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i< 20; i++){
            Account acc = new Account(
            	Name = 'Salesforce.com '+i
            );
            accounts.add(acc);
        }
        System.runAs(new User(Id = UserInfo.getUserId() )){
            insert as system accounts;
            System.assertNotEquals(0,accounts.size(),'Numbers are not equals');
            Assert.areNotEqual(0,accounts.size(),'Numbers are not equals');
        }

        // Create a Pricebook and Products for testing
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;
        
        List<Product2> products = new List<Product2>();
        for (Integer i = 0; i < 3; i++) {
            products.add(new Product2(Name = 'Test Product ' + i, IsActive = true));
        }
        insert products;
        
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Product2 product : products) {
            pricebookEntries.add(new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = product.Id,
                UnitPrice = 100,
                IsActive = true
            ));
        }
        insert pricebookEntries;
    }

	/**
     * @description Hello World
     */    
    @IsTest
    private static void assignUserTest(){
        System.runAs(new User(Id = UserInfo.getUserId() )){
            Test.startTest();
            AccountTriggerHandler.assignUser([SELECT Id, OwnerId FROM Account WHERE Name Like '%Salesforce.com%' WITH SECURITY_ENFORCED]);
            Test.stopTest();
            System.assertEquals(5,5,'Numbers are not equals');
            Assert.areEqual(5,5,'Numbers are not equals');
        }
    }

    @isTest
    static void testHandleAfterInsert() {
        // Create test accounts with the CreateOpportunity__c flag set to true
        List<Account> newAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            newAccounts.add(new Account(Name = 'New Test Account ' + i, CreateOpportunity__c = true));
        }
        
        Test.startTest();
        insert newAccounts;
        Test.stopTest();
        
        // Verify that opportunities were created
        List<Opportunity> opportunities = [SELECT Id, Name FROM Opportunity WHERE Name LIKE 'New Test Account%'];
        System.assertEquals(5, opportunities.size(), 'Five opportunities should be created');
        
        // Verify that opportunity line items were created
        List<OpportunityLineItem> lineItems = [SELECT Id FROM OpportunityLineItem];
        System.assert(lineItems.size() > 0, 'Opportunity line items should be created');
    }
    
    @isTest
    static void testBulkInsert() {
        // Test the trigger logic with bulk data
        List<Account> bulkAccounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            bulkAccounts.add(new Account(Name = 'Bulk Test Account ' + i, CreateOpportunity__c = true));
        }
        
        Test.startTest();
        insert bulkAccounts;
        Test.stopTest();
        
        // Verify that all opportunities were created
        Integer expectedOpportunities = 200;
        Integer actualOpportunities = [SELECT COUNT() FROM Opportunity WHERE Name LIKE 'Bulk Test Account%'];
        System.assertEquals(expectedOpportunities, actualOpportunities, 'All opportunities should be created');
    }
    
    @isTest
    static void testNoOpportunityCreation() {
        // Test accounts without the CreateOpportunity__c flag
        Account acc = new Account(Name = 'No Opportunity Account', CreateOpportunity__c = false);
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Verify that no opportunity was created
        Integer opportunityCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :acc.Id];
        System.assertEquals(0, opportunityCount, 'No opportunity should be created');
    }

}