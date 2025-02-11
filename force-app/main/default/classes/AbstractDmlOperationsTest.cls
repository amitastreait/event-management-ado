/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
@isTest
public class AbstractDmlOperationsTest {
    
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1');
        Account testAccount2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{testAccount1, testAccount2};
    }

    @isTest
    static void testInsertRecords() {
        AbstractDmlOperations dmlOps = new AbstractDmlOperations();
        
        // Prepare test data
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 3'),
            new Account(Name = 'Test Account 4')
        };

        // Call the method
        Test.startTest();
        dmlOps.insertRecords(accounts);
        dmlOps.insertRecords(new Account(Name = 'Test Account 4'));
        Test.stopTest();

        // Verify the records were inserted
        List<Account> insertedAccounts = [SELECT Id, Name FROM Account WHERE Name IN ('Test Account 3', 'Test Account 4')];
        System.assertEquals(3, insertedAccounts.size(), 'Two accounts should have been inserted');
    }

    @isTest
    static void testUpdateRecords() {
        AbstractDmlOperations dmlOps = new AbstractDmlOperations();
        
        // Get the test accounts
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];
        
        // Update the accounts
        for (Account acc : accounts) {
            acc.Name += ' - Updated';
        }

        // Call the method
        Test.startTest();
        dmlOps.updateRecords(accounts);
        dmlOps.updateRecords(accounts.get(0));
        Test.stopTest();

        // Verify the records were updated
        List<Account> updatedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account% - Updated'];
        System.assertEquals(accounts.size(), updatedAccounts.size(), 'All accounts should have been updated');
    }

    @isTest
    static void testDeleteRecords() {
        AbstractDmlOperations dmlOps = new AbstractDmlOperations();
        
        // Get the test accounts
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];

        // Call the method
        Test.startTest();
        dmlOps.deleteRecords(accounts);
        Test.stopTest();

        // Verify the records were deleted
        List<Account> deletedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];
        System.assertEquals(0, deletedAccounts.size(), 'All accounts should have been deleted');
    }

    @isTest
    static void testDeleteRecord() {
        AbstractDmlOperations dmlOps = new AbstractDmlOperations();
        
        // Get the test accounts
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];

        // Call the method
        Test.startTest();
        dmlOps.deleteRecords(accounts.get(0));
        Test.stopTest();

        // Verify the records were deleted
        List<Account> deletedAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];
        System.assertEquals(1, deletedAccounts.size(), 'All accounts should have been deleted');
    }

    @isTest
    static void testUpsertRecords() {
        AbstractDmlOperations dmlOps = new AbstractDmlOperations();
        
        // Prepare test data
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 5'),
            new Account(Name = 'Test Account 6')
        };

        Schema.SObjectField accountIdField = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Id');
        // Call the method
        Test.startTest();
        dmlOps.upsertRecords(accounts, accountIdField);
        dmlOps.upsertRecords(accounts.get(0), accountIdField);
        Test.stopTest();

        // Verify the records were upserted
        List<Account> upsertedAccounts = [SELECT Id, Name FROM Account WHERE Name IN ('Test Account 5', 'Test Account 6')];
        System.assertEquals(2, upsertedAccounts.size(), 'Two accounts should have been upserted');
    }

    @isTest
    static void testOverrideInsertRecords() {
        AbstractDmlOperations dmlOps = new AbstractDmlOperations();
        
        // Prepare test data
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 7'),
            new Account(Name = 'Test Account 8')
        };
        // Call the method
        Test.startTest();
        dmlOps.insertRecords(accounts);
        Test.stopTest();

        // Verify the records were inserted
        List<Account> insertedAccounts = [SELECT Id, Name FROM Account WHERE Name IN ('Test Account 7', 'Test Account 8')];
        System.assertEquals(2, insertedAccounts.size(), 'Two accounts should have been inserted');
    }
}