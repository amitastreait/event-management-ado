public with sharing class PermUtils {
    
    @AuraEnabled
    public static string BLAHBLAH(){
        try {
            return 'Hello World';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean hasBrowseSolutions(){
        return SolutionsUtils.hasBrowseSolutions();
    }
}