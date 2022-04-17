/**********************************************************************************************************************
* Name               : CommonUtility
* Description        : Utility class to write generic / reusable methods 
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
public class CommonUtility {
	
    /**********************************************************************************************
    * @Description  : Method to check if trigger needs to execute or not
    * @Params       : SObjectType sObjectName => Trigger object name
    * @Return       : void
    **********************************************************************************************/
    public static Boolean isTriggerDisabled(SObjectType sObjectName){
        Trigger_Setting__mdt triggerMeta ;
        for( Trigger_Setting__mdt tsm : [ SELECT DeveloperName, is_Active__c, Object_Name__c, Disable_Trigger__c
                                          FROM Trigger_Setting__mdt 
                                          WHERE Object_Name__c=:String.valueOf(sObjectName) 
                                          LIMIT 1] ){
            triggerMeta = tsm;
        }
        
        if( triggerMeta != null && triggerMeta.Disable_Trigger__c ){
            return true;
        }else{
            return false;
        }        
    }
}