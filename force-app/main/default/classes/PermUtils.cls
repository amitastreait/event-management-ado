public with sharing class PermUtils {
    @AuraEnabled
    public static Boolean hasBrowseSolutions(){
        return SolutionsUtils.hasBrowseSolutions();
    }
}