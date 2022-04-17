/**********************************************************************************************************************
* Name               : TransactionItemTriggerHandler
* Description        : Handler class for Transaction Item Trigger
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
public class TransactionItemTriggerHandler {

    List< TransactionItem__c > recordNewList = new List< TransactionItem__c >();
    List< TransactionItem__c > recordOldList = new List< TransactionItem__c >();
    Map< Id, TransactionItem__c > recordNewMap = new Map<Id, TransactionItem__c >();
    Map< Id, TransactionItem__c > recordOldMap = new Map<Id, TransactionItem__c >();
    Boolean isInsert, isUpdate, isDelete, isUndelete, isBefore, isAfter = false;
    public static boolean recursionController = false;
    
    public TransactionItemTriggerHandler( List<TransactionItem__c> newList, 
                                          List<TransactionItem__c> oldList, 
                                          Map<Id, TransactionItem__c> newMap, 
                                          Map<Id, TransactionItem__c> oldMap, 
                                          Boolean isInsert, 
                                          Boolean isUpdate, 
                                          Boolean isDelete, 
                                          Boolean isUndelete, 
                                          Boolean isBefore, 
                                          Boolean isAfter){
        this.recordNewList = newList;
        this.recordOldList = oldList;
        this.recordNewMap = newMap;
        this.recordOldMap = oldMap;
        this.isInsert = isInsert;
        this.isUpdate = isUpdate;
        this.isDelete = isDelete;
        this.isUndelete = isUndelete;
        this.isBefore = isBefore;
        this.isAfter = isAfter;        
    }

    public void AfterInsertEvent() {
        sendTransectionItemToERP( recordNewList, null );
    }
    
    public void AfterUpdateEvent() {
        sendTransectionItemToERP( recordNewList, recordOldMap );
    }
    
    public void BeforeInsertEvent() {
    }
    
    public void BeforeUpdateEvent() {
    }

    public void BeforeDeleteEvent() {
    }
    
    public void AfterDeleteEvent() {
    }
    
    public void AfterUndeleteEvent() {
    }
    

    /**********************************************************************************************
    * @Description  : Method to send Transaction Item Detais to ERP
    * @Params       : List< TransactionItem__c > newList 
    * @Params       : Map< Id, TransactionItem__c > oldMap 
    * @Return       : void
    **********************************************************************************************/
    public static void sendTransectionItemToERP( List< TransactionItem__c > newList, Map< Id, TransactionItem__c > oldMap ){
        
        Set< Id > setTransectionIds = new Set< Id >();
        Set< Id > setTransectionIdsToProcess = new Set< Id >();
        Map< Id, Transaction__c > mapTransectionIdToTransection = new Map< Id, Transaction__c >();
        Map< Id, List< TransactionItem__c >> mapTransIdToTransItemList = new Map< Id, List< TransactionItem__c >>();
        
        for( TransactionItem__c tItem : newList ){
            if( oldMap == null || oldMap.get(tItem.Id).Transaction__c != tItem.Transaction__c ){
                setTransectionIds.add( tItem.Transaction__c );
            }
        }
        
        if( !setTransectionIds.isEmpty() ){
            mapTransectionIdToTransection = new Map< Id, Transaction__c >( [ SELECT Id, Transaction_Count__c FROM Transaction__c WHERE Id IN : setTransectionIds ] );
        
            for( TransactionItem__c tItem : [ SELECT Id, Name, Transaction__c FROM TransactionItem__c WHERE Transaction__c IN : setTransectionIds ] ){
                if( !mapTransIdToTransItemList.containsKey( tItem.Transaction__c ) ){
                    mapTransIdToTransItemList.put( tItem.Transaction__c, new List< TransactionItem__c >() );
                }
                mapTransIdToTransItemList.get( tItem.Transaction__c ).add( tItem );
            }
        }
        
        for( Transaction__c transection : mapTransectionIdToTransection.values() ){
            if( transection.Transaction_Count__c == mapTransIdToTransItemList.get( transection.Id ).size() ){
                setTransectionIdsToProcess.add( transection.Id );
            }
        }
        
        if( !setTransectionIdsToProcess.isEmpty() ){
            TransactionIntegrationBatch bc = new TransactionIntegrationBatch( setTransectionIdsToProcess );
            Database.executeBatch( bc, 1 );
        }
    }
}