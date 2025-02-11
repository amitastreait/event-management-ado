/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
public interface IDMLInsert {
    void insertRecords(List<SObject> records);
    void insertRecords(SObject record);
}