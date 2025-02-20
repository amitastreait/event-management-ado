public with sharing class PermUtils {
    @AuraEnabled
    public static Boolean hasBrowseSolutions(){
        return SolutionsUtils.hasBrowseSolutions();
    }

    @AuraEnabled
    public static Boolean hasBrowseSolutions1(){
        return SolutionsUtils.hasBrowseSolutions();
    }
}