/**********************************************************************************************************************
* Name               : TransactionTriggerHandler
* Description        : Handler class for Transaction Trigger
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
public class TransactionTriggerHandler {
    List< Transaction__c > recordNewList = new List< Transaction__c >();
    List< Transaction__c > recordOldList = new List< Transaction__c >();
    Map< Id, Transaction__c > recordNewMap = new Map<Id, Transaction__c >();
    Map< Id, Transaction__c > recordOldMap = new Map<Id, Transaction__c >();
    Boolean isInsert, isUpdate, isDelete, isUndelete, isBefore, isAfter = false;
    public static boolean recursionController = false;

    public TransactionTriggerHandler( List< Transaction__c > newList, 
                                      List< Transaction__c > oldList, 
                                      Map< Id, Transaction__c > newMap, 
                                      Map< Id, Transaction__c > oldMap, 
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
    }
    
    public void AfterUpdateEvent() {
        reSendTransectionItemToERP( recordNewList, recordOldMap );
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
    * @Description  : Method to retry / resend Transaction Item Detais to ERP
    * @Params       : List< Transaction__c > newList 
    * @Params       : Map< Id, Transaction__c > oldMap 
    * @Return       : void
    **********************************************************************************************/
    public static void reSendTransectionItemToERP( List< Transaction__c > newList, Map< Id, Transaction__c > oldMap ){
        Set< Id > setTransactionIds = new Set< Id >();
        Set< Id > setTransactionIdsToProcess = new Set< Id >();
        Map< Id, Transaction__c > mapTransectionIdToTransection = new Map< Id, Transaction__c >();
        Map< Id, List< TransactionItem__c >> mapTransIdToTransItemList = new Map< Id, List< TransactionItem__c >>();

        for( Transaction__c trans : newList ){
            if( oldMap.get(trans.Id).Integration_Status__c != trans.Integration_Status__c && trans.Integration_Status__c == 'Resend' ){
                setTransactionIds.add( trans.Id );
            }
        }
        
        if( !setTransactionIds.isEmpty() ){
            mapTransectionIdToTransection = new Map< Id, Transaction__c >( [ SELECT Id, Transaction_Count__c FROM Transaction__c WHERE Id IN : setTransactionIds ] );
        
            for( TransactionItem__c tItem : [ SELECT Id, Name, Transaction__c FROM TransactionItem__c WHERE Transaction__c IN : setTransactionIds ] ){
                if( !mapTransIdToTransItemList.containsKey( tItem.Transaction__c ) ){
                    mapTransIdToTransItemList.put( tItem.Transaction__c, new List< TransactionItem__c >() );
                }
                mapTransIdToTransItemList.get( tItem.Transaction__c ).add( tItem );
            }
        }
        
        for( Transaction__c transection : mapTransectionIdToTransection.values() ){
            if( transection.Transaction_Count__c == mapTransIdToTransItemList.get( transection.Id ).size() ){
                setTransactionIdsToProcess.add( transection.Id );
            }
        }
        
        if( !setTransactionIdsToProcess.isEmpty() ){
            TransactionIntegrationBatch bc = new TransactionIntegrationBatch( setTransactionIdsToProcess );
            Database.executeBatch( bc, 1 );
        }
    }
}
