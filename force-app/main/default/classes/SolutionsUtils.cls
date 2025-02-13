public with sharing class SolutionsUtils {
    public static Boolean hasBrowseSolutions(){
        return System.FeatureManagement.checkPermission('Browse_Panther_Solutions');
    }
    public static Boolean hasBrowseSolutionsDummy(){
        return System.FeatureManagement.checkPermission('Browse_Panther_Solutions');
    }
}