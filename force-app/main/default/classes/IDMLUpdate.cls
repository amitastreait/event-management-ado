/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
public interface IDMLUpdate {
    void updateRecords(List<SObject> records);
    void updateRecords(SObject record);
}