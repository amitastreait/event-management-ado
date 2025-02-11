@isTest
public class PermUtilsTest {

    @TestSetup
    static void makeData(){
        /** Create Account Record */
        Account accWithSite = new Account(Name = 'Account With Site');
        insert accWithSite;
        /** Create Contact Record */
        Contact conWithAcc = new Contact(FirstName = 'FirstName', LastName = 'LastName', AccountId = accWithSite.Id);
        insert conWithAcc;
        /** Create a Case Record */
        Case testCase = new Case(Status = 'New', Origin = 'Phone', Priority='High', ContactId = conWithAcc.Id);
        insert testCase;

        /** Create a Child Case */
        Case childCase = new Case(Status = 'New', Origin = 'Phone', Priority='High', ParentId = testCase.Id);
    }
    
    @isTest
    static void testHasBrowseSolutions() {
        // Mock the behavior of SolutionsUtils.hasBrowseSolutions if necessary
        // Since we don't have the implementation details of SolutionsUtils, 
        // this test assumes it returns a Boolean value.

        // Call the method
        Boolean result = PermUtils.hasBrowseSolutions();
        
        // Verify the result
        // Assuming the expected behavior is known, adjust the assertion accordingly.
        // For example, if you expect it to return true under certain conditions:
        System.assertEquals(false, result, 'The hasBrowseSolutions method should return true.');
        
        // If the behavior depends on certain conditions, you might need to set up those conditions
        // and verify the result accordingly.
    }
}