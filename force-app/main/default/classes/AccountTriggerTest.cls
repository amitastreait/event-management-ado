/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-17-2025
 * @last modified by  : Amit Singh
**/
@isTest
private class AccountTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test data that will be used in multiple test methods
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
        /** Added a Sample Comment */
    }
    
    @isTest
    static void testHandleAfterInsert() {
        // Test the after insert trigger logic
        List<Account> newAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            newAccounts.add(new Account(Name = 'New Test Account ' + i));
        }
        
        Test.startTest();
        insert newAccounts;
        Test.stopTest();
        
        // Add assertions to verify the expected outcomes
        // For example, if the trigger logic updates a field, verify that update
        for (Account acc : [SELECT Id, Name FROM Account WHERE Name LIKE 'New Test Account%']) {
            System.assertNotEquals(null, acc.Id, 'Account ID should not be null');
            // Add more assertions as needed
        }
    }
    
    @isTest
    static void testBulkInsert() {
        // Test the trigger logic with bulk data
        List<Account> bulkAccounts = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            bulkAccounts.add(new Account(Name = 'Bulk Test Account ' + i));
        }
        
        Test.startTest();
        insert bulkAccounts;
        Test.stopTest();
        
        // Add assertions to verify the expected outcomes
        System.assertEquals(200, [SELECT COUNT() FROM Account WHERE Name LIKE 'Bulk Test Account%'], 'All accounts should be inserted');
    }
    
    @isTest
    static void testTriggerWithExistingData() {
        // Test the trigger logic when there is existing data in the system
        Account existingAccount = [SELECT Id, Name FROM Account LIMIT 1];
        
        Account newAccount = new Account(Name = 'Existing Data Test Account');
        
        Test.startTest();
        insert newAccount;
        Test.stopTest();
        
        // Add assertions to verify the expected outcomes
        System.assertNotEquals(null, newAccount.Id, 'New account ID should not be null');
    }
}