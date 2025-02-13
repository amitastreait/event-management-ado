/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-06-2025
 * @last modified by  : Amit Singh
**/
// InvoicePDFController.cls
public class InvoicePDFController {

    public Invoice__c invoiceRecord { get; set; }

    public CompanyInfo companyInfo { get; set; }
    
    public InvoicePDFController() {
        // Initialize with dummy data
        
        String invoiceId = ApexPages.currentPage().getParameters().get('id');
        invoiceRecord = [SELECT Id, Name, Event__c, Description__c, Status__c, DueDate__c, SubTotal__c, GrandTotal__c, Discount_Amount__c, Event__r.LogoUrl__c,
                   	TaxAmount__c, Quantity__c, InvoiceDate__c, Sponsor__c, Event__r.Name, Event__r.Location__r.Name, Event__r.Email__c, Event__r.Phone__c,
                    Sponsor__r.Name, Sponsor__r.Website__c, Sponsor__r.LogoUrl__c, Event__r.Location__r.Street__c, Event__r.Location__r.City__c, Event__r.Location__r.State__c,
                    Event__r.Location__r.PostalCode__c, Event__r.Location__r.Country__c,
                    Sponsor__r.PrimaryContact__r.Name, Sponsor__r.PrimaryContact__r.Email, Sponsor__r.PrimaryContact__r.Phone,
                    Sponsor__r.PrimaryContact__r.Account.BillingStreet, Sponsor__r.PrimaryContact__r.Account.BillingCity, 
                    Sponsor__r.PrimaryContact__r.Account.BillingState, Sponsor__r.PrimaryContact__r.Account.BillingPostalCode, 
                    Sponsor__r.PrimaryContact__r.Account.BillingCountry,
                    (   SELECT Id, Name, Description__c, Product__c, Product__r.Name, Quantity__c, Amount__c, TotalAmount__c,TotalAfterDiscount__c, GrandTotal__c,
                        Discount__c, DiscountAmount__c, Tax__c, TaxAmount__c
                        FROM Invoice_Line_Items__r
                   )
                   FROM Invoice__c
                   WHERE Id = :invoiceId
        ];
        setupDummyData();
    }
    
    private void setupDummyData() {
        companyInfo = new CompanyInfo();
        companyInfo.name = this.invoiceRecord.Event__r.Name;
        companyInfo.address = this.invoiceRecord.Event__r.Location__r.Name + '\n' + this.invoiceRecord.Event__r.Location__r.Street__c + ', ' + this.invoiceRecord.Event__r.Location__r.City__c + ', ' + this.invoiceRecord.Event__r.Location__r.State__c + ', ' + this.invoiceRecord.Event__r.Location__r.PostalCode__c + ', ' + this.invoiceRecord.Event__r.Location__r.Country__c;
        companyInfo.phone = this.invoiceRecord.Event__r.Phone__c;
        companyInfo.email = this.invoiceRecord.Event__r.Email__c;
        companyInfo.clientAddress = this.invoiceRecord.Sponsor__r.PrimaryContact__r.Account.BillingStreet + ', ' + this.invoiceRecord.Sponsor__r.PrimaryContact__r.Account.BillingCity + ', ' + this.invoiceRecord.Sponsor__r.PrimaryContact__r.Account.BillingState + ', ' + this.invoiceRecord.Sponsor__r.PrimaryContact__r.Account.BillingPostalCode + ', ' + this.invoiceRecord.Sponsor__r.PrimaryContact__r.Account.BillingCountry;
    }
    
    public class CompanyInfo {
        public String name { get; set; }
        public String address { get; set; }
        public String clientAddress { get; set; }
        public String phone { get; set; }
        public String email { get; set; }
    }
}