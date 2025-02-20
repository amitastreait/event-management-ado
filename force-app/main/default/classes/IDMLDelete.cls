/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
public interface IDMLDelete {
    void deleteRecords(List<SObject> records);
    void deleteRecords(SObject record);
}