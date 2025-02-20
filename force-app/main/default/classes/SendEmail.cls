/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-07-2025
 * @last modified by  : Amit Singh
**/
public without sharing class SendEmail {

    
    public static void sendEmail(String invoiceId){
        InvoiceController.getInvoice(invoiceId);
        String templateName = InvoiceController.invoice.Event__r.InvoiceEmailTemplateName__c;
        Id templateId = [SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName = :templateName OR Name =: templateName LIMIT 1]?.Id;
        if(templateId == null){
            throw new IllegalArgumentException('Email template not found');
        }
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId, InvoiceController.invoice.Sponsor__r.PrimaryContact__c, invoiceId);
        String[] toAddresses = new String[] {InvoiceController.invoice.Event__r.Email__c};
        mail.setCCAddresses(toAddresses);

        /** Add the attachment to the Email */
        PageReference pdfPage = Page.Invoice;
        pdfPage.getParameters().put('id', invoiceId);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdfPage.getContentAsPDF();
        } else {
            pdfBlob = Blob.valueOf('Test');
        }
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setFileName(InvoiceController.invoice.Name+'.pdf');
        attach.setBody(pdfBlob);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });

        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if (!results[0].isSuccess()) {
            throw new EmailException('Email not sent');
        }

    }
}