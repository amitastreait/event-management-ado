/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-31-2025
 * @last modified by  : Amit Singh
**/
public virtual class AbstractDmlOperations implements IDMLInsert, IDMLUpsert, IDMLUpdate, IDMLDelete {
    public virtual void upsertRecords(List<SObject> records, Schema.SObjectField externalIdField) {
        List<Database.UpsertResult> results = Database.upsert(records, externalIdField, false);
    }
    public virtual void upsertRecords(SObject record, Schema.SObjectField externalIdField) {
        List<Database.UpsertResult> results = Database.upsert(new List<SObject>{record}, externalIdField, false);
    }
    public virtual void insertRecords(List<SObject> records) {
        List<Database.SaveResult> results = Database.insert(records, false);
    }
    public virtual void insertRecords(SObject record) {
        List<Database.SaveResult> results = Database.insert(new List<SObject>{record}, false);
    }
    public virtual void updateRecords(List<SObject> records) {
        List<Database.SaveResult> results = Database.update(records, false);
    }
    public virtual void updateRecords(SObject record) {
        List<Database.SaveResult> results = Database.update(new List<SObject>{record}, false);
    }
    public virtual void deleteRecords(List<SObject> records) {
        List<Database.DeleteResult> results = Database.delete(records, false);
    }
    public virtual void deleteRecords(SObject record) {
        List<Database.DeleteResult> results = Database.delete(new List<SObject>{record}, false);
    }
    // Some more methods
}