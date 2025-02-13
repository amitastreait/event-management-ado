/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-06-2025
 * @last modified by  : Amit Singh
**/
@isTest
public class InvoicePDFControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test data for Event
        Venue__c location = new Venue__c(
            Name = 'Test Location',
            Street__c = '123 Test St',
            City__c = 'Test City',
            State__c = 'Test State',
            PostalCode__c = '12345',
            Country__c = 'Test Country'
        );
        insert location;

        // Create a test event record
        Event__c testEvent = new Event__c(
            Name = 'Test Event',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(1),
            Location__c = location.Id,
            TicketPrefix__c = 'TICKET-',
            InvoicePrefix__c = 'INV-',
            TicketPrice__c = 10.00,
            EarlybirdTicketPrice__c = 10.00,
            ShortDescription__c = 'Sample Description',
            Status__c = 'Planned',
            Phone__c = '123-456-7890',
            Email__c = 'amit@onedreamin.com'
        );
        insert testEvent;

        // Create test data for Account and Contact
        Account account = new Account(
            Name = 'Test Account',
            BillingStreet = '456 Test Ave',
            BillingCity = 'Test City',
            BillingState = 'Test State',
            BillingPostalCode = '67890',
            BillingCountry = 'Test Country'
        );
        insert account;

        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = account.Id
        );
        insert contact;

        // Create test data for Sponsor
        Sponsor__c sponsor = new Sponsor__c(
            Name = 'Test Sponsor',
            PrimaryContact__c = contact.Id,
            Tier__c = 'Gold',
            Amount__c = 1000.00
        );
        insert sponsor;

        // Create test data for Invoice
        Invoice__c invoice = new Invoice__c(
            Event__c = testEvent.Id,
            Sponsor__c = sponsor.Id
        );
        insert invoice;
    }

    @isTest
    static void testInvoicePDFController() {
        // Retrieve the test invoice
        Invoice__c testInvoice = [SELECT Id FROM Invoice__c LIMIT 1];

        PageReference testPage = Page.Invoice; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('id', testInvoice.Id);
        
        // Call the method to be tested
        Test.startTest();
        InvoicePDFController controller = new InvoicePDFController();
        Test.stopTest();

        // Verify the results
        System.assertNotEquals(null, controller.companyInfo, 'CompanyInfo should not be null');
        System.assertEquals('Test Event', controller.companyInfo.name, 'Company name should match');
    }
}