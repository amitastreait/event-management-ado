/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
@isTest
public class UploadFileControllerTest {
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    @isTest
    static void testUploadFile() {
        // Get the test account
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Prepare test data
        String recordId = testAccount.Id;
        String fileContent = 'VGhpcyBpcyBhIHRlc3QgZmlsZSBjb250ZW50Lg=='; // Base64 encoded string of "This is a test file content."
        String fieldApiName = 'Name';
        String fileName = 'TestFile.txt';

        // Call the method
        Test.startTest();
        UploadFileController.uploadFile(recordId, fileContent, fieldApiName, fileName);
        Test.stopTest();

        // Verify the ContentVersion record
        ContentVersion contentVersion = [SELECT Id, Title, VersionData, PathOnClient, FirstPublishLocationId FROM ContentVersion WHERE Title = :fileName LIMIT 1];
        System.assertNotEquals(null, contentVersion, 'ContentVersion should not be null');
        System.assertEquals(fileName, contentVersion.Title, 'ContentVersion title should match the file name');
        System.assertEquals(recordId, contentVersion.FirstPublishLocationId, 'ContentVersion FirstPublishLocationId should match the recordId');

        // Verify the ContentDistribution record
        ContentDistribution contentDistribution = [SELECT Id, ContentVersionId, Name, RelatedRecordId FROM ContentDistribution WHERE Name = :fileName LIMIT 1];
        System.assertNotEquals(null, contentDistribution, 'ContentDistribution should not be null');
        System.assertEquals(contentVersion.Id, contentDistribution.ContentVersionId, 'ContentDistribution ContentVersionId should match the ContentVersion Id');
        System.assertEquals(recordId, contentDistribution.RelatedRecordId, 'ContentDistribution RelatedRecordId should match the recordId');
    }
}