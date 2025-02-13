public without sharing class AddAttendeeController {
    
    @AuraEnabled
    public static void addAttendee(InputWrapper wrapper){
        try {
            Attendee__c attendee = new Attendee__c(
                Name = wrapper.name, 
                Email__c = wrapper.email,
                CompanyName__c = wrapper.companyName,
                Phone__c = wrapper.phone,
                JobTitle__c = wrapper.jobTitle
            );
            insert as system attendee;

            Event__c eventRecord = fetchEventDetails(wrapper.eventId);

            // Create Ticket record
            Ticket__c ticket = new Ticket__c(
                Attendee__c = attendee.Id,
                Name = eventRecord.TicketPrefix__c +''+generateRandomTicketId(),
                Event__c = wrapper.eventId,
                Status__c = 'Created',
                TicketPrice__c = eventRecord.EarlybirdActive__c ? eventRecord.EarlybirdTicketPrice__c : eventRecord.TicketPrice__c,
                TicketType__c = eventRecord.EarlybirdActive__c ? 'Earlybird' : 'Regular',
                VenueName__c = eventRecord.Location__r.Name,
                TicketSent__c = false
            );
            insert as system ticket;

            // Logic to generate and send the ticket PDF
            // This is a placeholder for the actual PDF generation and sending logic
            sendTicketPDF(attendee.Email__c, ticket);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    private static void sendTicketPDF(String email, Ticket__c ticket) {
        // Implement PDF generation and email sending logic here
        ticket.TicketSent__c = true;
        update as system ticket;
    }

    private static Event__c fetchEventDetails(String eventId) {
        // Check if the user has read access to Event__c
        if (!Schema.sObjectType.Event__c.isAccessible()) {
            throw new AuraHandledException('You do not have permission to access Event records.');
        }

        // Check field-level security for each field
        if (!Schema.sObjectType.Event__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.Event__c.fields.Start_Date__c.isAccessible() ||
            !Schema.sObjectType.Event__c.fields.End_Date__c.isAccessible() ||
            !Schema.sObjectType.Event__c.fields.Location__c.isAccessible() ||
            !Schema.sObjectType.Event__c.fields.InvoicePrefix__c.isAccessible() ||
            !Schema.sObjectType.Event__c.fields.TicketPrefix__c.isAccessible()) {
            throw new AuraHandledException('You do not have permission to access one or more fields of Event object.');
        }
        
        return [
            SELECT Id, Name, Start_Date__c, End_Date__c, TicketPrice__c, EarlybirdTicketPrice__c,
            EarlybirdActive__c,
            Location__c, Location__r.Name, InvoicePrefix__c, TicketPrefix__c
            FROM Event__c
            WHERE Id = :eventId
        ];
    }

    public static String generateRandomTicketId() {
        // Generate a random number between 100000 and 999999
        Integer randomId = (Integer)(Math.random() * 900000) + 100000;
        return String.valueOf(randomId);
    }

    public class InputWrapper {
        @AuraEnabled
        public String name          { get; set; }
        @AuraEnabled
        public String email         { get; set; }
        @AuraEnabled
        public String phone         { get; set; }
        @AuraEnabled
        public String jobTitle      { get; set; }
        @AuraEnabled
        public String companyName   { get; set; }
        @AuraEnabled
        public String eventId       { get; set; }
    }
}