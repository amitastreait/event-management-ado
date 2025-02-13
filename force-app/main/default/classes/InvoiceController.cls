/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-07-2025
 * @last modified by  : Amit Singh
**/
public without sharing class InvoiceController {
    public static Invoice__c invoice { get; set; }

    public InvoiceController() {
        String invoiceId = ApexPages.currentPage().getParameters().get('id');
        getInvoice(invoiceId);
    }

    public static void getInvoice(String invoiceId){
        invoice = [SELECT Id, Name, Event__c, Description__c, Status__c, DueDate__c, GrandTotal__c, Discount_Amount__c, Event__r.Email__c,
                   	TaxAmount__c, Quantity__c, InvoiceDate__c, Sponsor__c, Sponsor__r.Name, Sponsor__r.PrimaryContact__c, Event__r.InvoiceEmailTemplateName__c,
                   (SELECT Id, Name, Description__c, Product__c, Product__r.Name, Quantity__c, Amount__c, 
                   TotalAmount__c,TotalAfterDiscount__c, GrandTotal__c,
                    Discount__c, DiscountAmount__c, Tax__c, TaxAmount__c
                    FROM Invoice_Line_Items__r
                   )
                   FROM
                   	Invoice__c
                   WHERE Id = :invoiceId
                  ];
    }

    @AuraEnabled
    public static Object generatePDF(String invoiceId){
        try {
            getInvoice(invoiceId);
            PageReference pdfPage = Page.Invoice;
            pdfPage.getParameters().put('id', invoiceId);
            Blob pdfBlob;
            if (!Test.isRunningTest()) {
                pdfBlob = pdfPage.getContentAsPDF();
            } else {
                pdfBlob = Blob.valueOf('Test');
            }

            List<ContentVersion> existingPDFs = [
                SELECT Id, Title, VersionData, ContentDocumentId
                FROM ContentVersion
                WHERE Title = :(invoice.Name+'.pdf')
                LIMIT 1
            ];
            if (!existingPDFs.isEmpty()) {
                ContentVersion newVersion = prepareContentVersion(invoice, pdfBlob);
                newVersion.ContentDocumentId = existingPDFs.get(0).ContentDocumentId;
                insert newVersion;
                pdfBlob = null;
                return newVersion.Id;
            }
            ContentVersion initialVersion = prepareContentVersion(invoice, pdfBlob);
            initialVersion.FirstPublishLocationId = invoice.Id;
            insert initialVersion;
            pdfBlob = null;
            return initialVersion.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Object saveAndEmailPDF(String invoiceId){
        try {
            /** Check if the Invoice PDF is generated then update the content and if not then create a new PDF  */
            Id recordId = (Id)generatePDF(invoiceId);
            SendEmail.sendEmail(invoiceId);
            /** Update the invoice Status to Awaiting Payment */
            Invoice__c inv = new Invoice__c();
            inv.Id = invoiceId;
            inv.Status__c = 'Awaiting Payment';
            update inv;
            return recordId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static ContentVersion prepareContentVersion(Invoice__c invoice, Blob pdfBlob){
        /** Insert content version */
        ContentVersion cv = new ContentVersion();
        cv.Title = invoice.Name+'.pdf';
        cv.PathOnClient = invoice.Name+'.pdf';
        cv.VersionData = pdfBlob;
        cv.Origin = 'H';
        return cv;
    }
}