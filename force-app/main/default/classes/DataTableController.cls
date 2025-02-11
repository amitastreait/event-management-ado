/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-18-2024
 * @last modified by  : Amit Singh
**/
public with sharing class DataTableController {
    
    @AuraEnabled(cacheable=true)
    public static Object getContactList(){
        if (!Contact.SObjectType.getDescribe().isAccessible() ||
            !Schema.SObjectType.Contact.fields.Name.isAccessible() ||
            !Schema.SObjectType.Contact.fields.Email.isAccessible() ||
            !Schema.SObjectType.Contact.fields.Phone.isAccessible() ||
            !Schema.SObjectType.Contact.fields.AccountId.isAccessible() ||
            !Schema.SObjectType.Account.fields.Name.isAccessible() ||
            !Schema.SObjectType.Contact.fields.OwnerId.isAccessible() ||
            !Schema.SObjectType.User.fields.Name.isAccessible()) {
            return new List<Contact>();
        }
        
        return [SELECT Id, Name, Email, Phone, AccountId, Account.Name, OwnerId, Owner.Name 
                FROM Contact 
                WHERE AccountId <> null 
                LIMIT 10];
    }
}