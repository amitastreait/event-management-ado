@isTest
public class FormulaEvaluatorTest {
    
    @testSetup
    static void setupTestData() {
        // Create an Account with a Site value
        Account accWithSite = new Account(Name = 'Account With Site', Site = 'Test Site');
        insert accWithSite;
        
        // Create an Account without a Site value
        Account accWithoutSite = new Account(Name = 'Account Without Site');
        insert accWithoutSite;
    }
    
    @isTest
    static void testEvaluateAccountWithSite() {
        // Fetch the Account with a Site value
        Account acc = [SELECT Id, Site FROM Account WHERE Name = 'Account With Site' LIMIT 1];
        
        // Evaluate the Account
        Test.startTest();
        FormulaEvaluator.evaluate(acc);
        Test.stopTest();
        
        // Verify the debug logs for expected output
        // Use a mock or check logs if possible
    }
    
    @isTest
    static void testEvaluateAccountWithoutSite() {
        // Fetch the Account without a Site value
        Account acc = [SELECT Id, Site FROM Account WHERE Name = 'Account Without Site' LIMIT 1];
        
        // Evaluate the Account
        Test.startTest();
        FormulaEvaluator.evaluate(acc);
        Test.stopTest();
        
        // Verify the debug logs for expected output
        // Use a mock or check logs if possible
    }
    
    @isTest
    static void testEvaluateFormulaEvaluatorAdmin() {
        // Create a FormulaEvaluator instance with isAdmin = true
        FormulaEvaluator evaluator = new FormulaEvaluator('Admin User', true);
        
        // Evaluate the FormulaEvaluator instance
        Test.startTest();
        FormulaEvaluator.evaluate(evaluator);
        Test.stopTest();
        
        // Verify the debug logs for expected output
        // Use a mock or check logs if possible
    }
    
    @isTest
    static void testEvaluateFormulaEvaluatorNonAdmin() {
        // Create a FormulaEvaluator instance with isAdmin = false
        FormulaEvaluator evaluator = new FormulaEvaluator('Non-Admin User', false);
        
        // Evaluate the FormulaEvaluator instance
        Test.startTest();
        FormulaEvaluator.evaluate(evaluator);
        Test.stopTest();
        
        // Verify the debug logs for expected output
        // Use a mock or check logs if possible
    }
    
    @isTest
    static void testEvaluateFormulaEvaluatorWithException() {
        // Create a FormulaEvaluator instance with isException = true
        FormulaEvaluator evaluator = new FormulaEvaluator('Exception User', false);
        evaluator.isException = true;
        
        // Evaluate the FormulaEvaluator instance
        Test.startTest();
        FormulaEvaluator.evaluate(evaluator);
        Test.stopTest();
        
        // Verify the debug logs for expected output
        // Use a mock or check logs if possible
    }
}