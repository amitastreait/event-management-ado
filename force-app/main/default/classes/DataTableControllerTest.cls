@isTest
public class DataTableControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create an Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create Contacts under the Account
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 15; i++) {
            Contact con = new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                Email = 'test' + i + '@example.com',
                Phone = '123-456-7890',
                AccountId = acc.Id
            );
            contacts.add(con);
        }
        insert contacts;
    }
    
    @isTest
    static void testGetContactList() {
        // Call the method
        List<Contact> contacts = (List<Contact>) DataTableController.getContactList();
        
        // Verify the results
        System.assertNotEquals(null, contacts, 'The contact list should not be null.');
        System.assertEquals(10, contacts.size(), 'The contact list should contain 10 contacts.');
        
        // Verify that all contacts have an AccountId
        for (Contact con : contacts) {
            System.assertNotEquals(null, con.AccountId, 'Each contact should have an AccountId.');
        }
    }
}