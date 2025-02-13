/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
public interface IDMLUpsert {
    void upsertRecords(List<SObject> records, Schema.SObjectField externalIdField);
    void upsertRecords(SObject record, Schema.SObjectField externalIdField);
}