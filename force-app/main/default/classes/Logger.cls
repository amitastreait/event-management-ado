/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-29-2025
 * @last modified by  : Amit Singh
**/
public with sharing class Logger {
    public static Boolean isException = True;
    public ErrorLog__c logRecord;
    public Logger() {
        this.logRecord = new ErrorLog__c();
    }
    public Logger withErrorMessage(String errorMessage) {
        this.logRecord.ErrorMessage__c = errorMessage;
        return this;
    }
    public Logger withStackTrace(String stackTrace) {
        this.logRecord.StackTrace__c = stackTrace;
        return this;
    }
    public Logger withComponentName(String componentName) {
        this.logRecord.ComponentName__c = componentName;
        return this;
    }
    public Logger withMethodName(String value) {
        this.logRecord.Function__c = value;
        return this;
    }
    public Logger withLogDateTime(DateTime value) {
        this.logRecord.LogDateTime__c = value;
        return this;
    }
    public Logger withLogLevel(String value) {
        this.logRecord.EventLevel__c = value;
        return this;
    }
    public Logger withFunctionality(String value) {
        this.logRecord.Functionality__c = value;
        return this;
    }
    public Logger withUser(String value) {
        this.logRecord.AffectedUser__c = value;
        return this;
    }
    public Logger withParentId(String value) {
        this.logRecord.ParentId__c = value;
        return this;
    }
    public Logger withParentName(String value) {
        this.logRecord.ParentName__c = value;
        return this;
    }
    public ErrorLog__c build() {
        insert as user this.logRecord;
        return this.logRecord;
    }
    public ErrorLog__c buildWithoutInsert() {
        return this.logRecord;
    }
}