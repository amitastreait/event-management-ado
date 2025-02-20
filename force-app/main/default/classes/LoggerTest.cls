/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-03-2025
 * @last modified by  : Amit Singh
**/
@isTest
public with sharing class LoggerTest {
    
    @testSetup
    static void setup() {
        /** Create An Account Record */
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    @isTest
    static void testWithErrorMessage() {
        Logger logger = new Logger()
            .withErrorMessage('Test Error Message')
            .withStackTrace('Test Stack Trace')
            .withComponentName('Test Component')
            .withMethodName('Test Method')
            .withLogDateTime(DateTime.now())
            .withLogLevel('ERROR')
            .withFunctionality('Test Functionality')
            .withUser(UserInfo.getUserId())
            .withParentId('001xx000003DHP0')
            .withParentName('Test Parent');
        ErrorLog__c log = logger.buildWithoutInsert();
        System.assertEquals('Test Error Message', log.ErrorMessage__c);
    }

    @isTest
    static void testBuild() {
        Logger logger = new Logger()
            .withErrorMessage('Test Error Message')
            .withStackTrace('Test Stack Trace')
            .withComponentName('Test Component')
            .withMethodName('Test Method')
            .withLogDateTime(DateTime.now())
            .withLogLevel('ERROR')
            .withFunctionality('Test Functionality')
            .withUser(UserInfo.getUserId())
            .withParentId('001xx000003DHP0')
            .withParentName('Test Parent');
        Test.startTest();
        ErrorLog__c log = logger.build();
        Test.stopTest();
        System.assertNotEquals(null, log.Id);
    }

    @isTest
    static void testBuildWithoutInsert() {
        Logger logger = new Logger().withErrorMessage('Test Error Message');
        ErrorLog__c log = logger.buildWithoutInsert();
        System.assertEquals(null, log.Id);
    }

    @isTest
    static void testMultipleFields() {
        DateTime now = DateTime.now();
        Logger logger = new Logger()
            .withErrorMessage('Test Error Message')
            .withStackTrace('Test Stack Trace')
            .withComponentName('Test Component')
            .withMethodName('Test Method')
            .withLogDateTime(now)
            .withLogLevel('ERROR')
            .withFunctionality('Test Functionality')
            .withUser(UserInfo.getUserId())
            .withParentId('001xx000003DHP0')
            .withParentName('Test Parent');
        
        ErrorLog__c log = logger.buildWithoutInsert();
        
        System.assertEquals('Test Error Message', log.ErrorMessage__c);
        System.assertEquals('Test Stack Trace', log.StackTrace__c);
        System.assertEquals('Test Component', log.ComponentName__c);
        System.assertEquals('Test Method', log.Function__c);
        System.assertEquals(now, log.LogDateTime__c);
        System.assertEquals('ERROR', log.EventLevel__c);
        System.assertEquals('Test Functionality', log.Functionality__c);
        System.assertEquals('001xx000003DHP0', log.ParentId__c);
        System.assertEquals('Test Parent', log.ParentName__c);
        String dmo = HousingData.jsonString;
    }
}