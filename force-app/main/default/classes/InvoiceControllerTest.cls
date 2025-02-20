/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-07-2025
 * @last modified by  : Amit Singh
**/
@isTest
public class InvoiceControllerTest {
    
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a test contact under the account
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id,
            Email = 'test.contact@example.com'
        );
        insert testContact;

        Sponsor__c sponsor = new Sponsor__c(
            Name = 'Test Sponsor',
            PrimaryContact__c = testContact.Id,
            Status__c = 'New',
            Tier__c = 'Gold',
            Website__c = 'http://www.example.com',
            Amount__c = 5000
        );
        insert sponsor;

        Venue__c venue = new Venue__c(Name = 'Stage');
        insert venue;

        // Create a test event record
        Event__c testEvent = new Event__c(
            Name = 'Test Event',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(1),
            Location__c = venue.Id,
            TicketPrefix__c = 'TICKET-',
            InvoicePrefix__c = 'INV-',
            TicketPrice__c = 10.00,
            EarlybirdTicketPrice__c = 10.00,
            ShortDescription__c = 'Sample Description',
            Status__c = 'Planned',
            InvoiceEmailTemplateName__c = 'Invoice_PDF_Email_for_Payment',
            Email__c = 'asingh@gmail.com'
        );
        insert testEvent;

        // Create a test invoice
        Invoice__c testInvoice = new Invoice__c(
            Name = 'Test Invoice',
            Event__c = testEvent.Id,
            Description__c = 'Test Description',
            Status__c = 'Draft',
            DueDate__c = Date.today().addDays(3),
            InvoiceDate__c = Date.today(),
            Sponsor__c = sponsor.Id
        );
        insert testInvoice;

        // Create a test product
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert testProduct;

        // Create test invoice line items
        InvoiceLine__c testLineItem = new InvoiceLine__c(
            Invoice__c = testInvoice.Id,
            Description__c = 'Test Line Item Description',
            Product__c = testProduct.Id,
            Quantity__c = 5,
            Amount__c = 200
        );
        insert testLineItem;
    }

    @isTest
    static void testInvoiceController() {
        // Set the current page parameters
        Test.setCurrentPageReference(new PageReference('/apex/InvoicePage'));
        ApexPages.currentPage().getParameters().put('id', [SELECT Id FROM Invoice__c LIMIT 1].Id);

        // Instantiate the controller
        InvoiceController controller = new InvoiceController();

        // Verify the controller's behavior
        System.assertNotEquals(null, InvoiceController.invoice, 'Invoice should not be null');
        System.assertEquals('Test Invoice', InvoiceController.invoice.Name, 'Invoice name should be "Test Invoice"');
        System.assertEquals(1, InvoiceController.invoice.Invoice_Line_Items__r.size(), 'There should be one invoice line item');
        System.assertNotEquals('Test Line Item', InvoiceController.invoice.Invoice_Line_Items__r[0].Name, 'Line item name should be "Test Line Item"');
    }

    @isTest
    static void testGenerateOrUpdatePDF_NewPDF() {
        // Retrieve the test invoice
        Invoice__c testInvoice = [SELECT Id, Name FROM Invoice__c LIMIT 1];

        // Call the method to be tested
        Test.startTest();
        InvoiceController.generatePDF(testInvoice.Id);
        Test.stopTest();

        // Verify that the PDF was created
        ContentVersion pdf = [SELECT Id, Title FROM ContentVersion WHERE Title = :(testInvoice.Name+'.pdf') LIMIT 1];
        System.assertNotEquals(null, pdf, 'PDF should be created');
        System.assertEquals(testInvoice.Name+'.pdf', pdf.Title, 'PDF title should match');
    }

    @isTest
    static void testGenerateOrUpdatePDF_UpdatePDF() {
        // Retrieve the test invoice
        Invoice__c testInvoice = [SELECT Id, Name FROM Invoice__c LIMIT 1];

        // Create an initial PDF
        ContentVersion initialPDF = new ContentVersion();
        initialPDF.Title = testInvoice.Name+'.pdf';
        initialPDF.PathOnClient = 'testInvoice.pdf' + '.pdf';
        initialPDF.VersionData = Blob.valueOf('Initial PDF Content');
        initialPDF.FirstPublishLocationId = testInvoice.Id;
        insert initialPDF;

        // Call the method to be tested
        Test.startTest();
        InvoiceController.saveAndEmailPDF(testInvoice.Id);
        Test.stopTest();

        // Verify that the PDF was updated
        ContentVersion updatedPDF = [SELECT Id, Title, VersionData FROM ContentVersion WHERE Title = :(testInvoice.Name+'.pdf') LIMIT 1];
        System.assertNotEquals(null, updatedPDF, 'PDF should be updated');
        System.assertEquals(testInvoice.Name+'.pdf', updatedPDF.Title, 'PDF title should match');
    }
}