@isTest
public with sharing class AddAttendeeControllerTest {

    @isTest
    static void testInputWrapper() {
        // Create an instance of InputWrapper with dummy data
        AddAttendeeController.InputWrapper inputWrapper = new AddAttendeeController.InputWrapper();
        inputWrapper.name = 'John Doe';
        inputWrapper.email = 'john.doe@example.com';
        inputWrapper.phone = '123-456-7890';
        inputWrapper.jobTitle = 'Software Engineer';
        inputWrapper.companyName = 'Tech Solutions';

        // Now you can use this inputWrapper instance in your tests
        System.assertEquals('John Doe', inputWrapper.name, 'Name should match the dummy data.');
        System.assertEquals('john.doe@example.com', inputWrapper.email, 'Email should match the dummy data.');
        System.assertEquals('123-456-7890', inputWrapper.phone, 'Phone should match the dummy data.');
        System.assertEquals('Software Engineer', inputWrapper.jobTitle, 'Job Title should match the dummy data.');
        System.assertEquals('Tech Solutions', inputWrapper.companyName, 'Company Name should match the dummy data.');
    }

    @isTest
    static void testCreateAttendeeAndTicket() {

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
            Status__c = 'Planned'
        );
        insert testEvent;

        // Create an instance of InputWrapper with dummy data
        AddAttendeeController.InputWrapper inputWrapper = new AddAttendeeController.InputWrapper();
        inputWrapper.name = 'John Doe';
        inputWrapper.email = 'john.doe@example.com';
        inputWrapper.phone = '123-456-7890';
        inputWrapper.jobTitle = 'Software Engineer';
        inputWrapper.companyName = 'Tech Solutions';
        inputWrapper.eventId = testEvent.Id;

        // Test data
        String testName = 'John Doe';
        String testEmail = 'john.doe@example.com';

        // Call the method
        Test.startTest();
        AddAttendeeController.addAttendee(inputWrapper);
        Test.stopTest();

        // Verify the attendee record was created
        Attendee__c createdAttendee = [SELECT Id, Name, Email__c FROM Attendee__c WHERE Email__c = :testEmail LIMIT 1];
        System.assertNotEquals(null, createdAttendee, 'Attendee should be created.');
        System.assertEquals(testName, createdAttendee.Name, 'Attendee name should match.');

        // Verify the ticket record was created
        Ticket__c createdTicket = [SELECT Id, Attendee__c FROM Ticket__c WHERE Attendee__c = :createdAttendee.Id LIMIT 1];
        System.assertNotEquals(null, createdTicket, 'Ticket should be created.');
    }
}