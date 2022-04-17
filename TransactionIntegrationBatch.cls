/**********************************************************************************************************************
* Name               : TransactionIntegrationBatch
* Description        : Batch class to do API call for Transaction and Transaction Item
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
global class TransactionIntegrationBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    Set< Id > setTransactionIdsToProcess = new Set< Id >();

    // Constructors 
    public TransactionIntegrationBatch(){
    }

    public TransactionIntegrationBatch( Set< Id > setTransactionIdsToProcess ){
        this.setTransactionIdsToProcess = setTransactionIdsToProcess;
    }
    
    global Database.QueryLocator start( Database.BatchableContext bc ) {
        String query = ' SELECT Id, Total_Cost__c, Total_Discount__c, Transaction_Date__c, Transaction_Count__c, ';
        query += ' ( SELECT Id, Name, Item_Cost__c, Item_Discount__c FROM TransactionItem__r  )';
        query += ' FROM Transaction__c  WHERE Id IN :setTransactionIdsToProcess ';
        
        return Database.getQueryLocator( query );
    }

    global void execute( Database.BatchableContext bc, List< Transaction__c > records ){       

        // The batch will be running with batch size = 1
        if( records != null && records.size() == 1 ){
            Transaction__c transactionRec = records[0];
            if( transactionRec != null ){
                TransactionIntegrationBatch.sendTransactionItemDataToERP( transactionRec );
            }
        }else{
            WrapperUtil.LogWrapper logWrap = new WrapperUtil.LogWrapper();
            logWrap.className = 'TransactionIntegrationBatch';
            logWrap.methodName = 'execute';
            logWrap.message = 'TransactionIntegrationBatch can only run with batch size = 1.';

            LogUtility.createLog( logWrap, true );
        }
    }   
     
    global void finish( Database.BatchableContext bc ){
    } 

    /**********************************************************************************************
    * @Description  : Method to send Transaction Item Detais to ERP
    * @Params       : Transaction__c transactionRec => transaction record 
    * @Return       : HttpResponse
    **********************************************************************************************/
    public static HttpResponse sendTransactionItemDataToERP( Transaction__c transactionRec ){
        
        List< WrapperUtil.TransactionItemPayload > lstTransactionItemPayload = new List< WrapperUtil.TransactionItemPayload >();
        
        if( transactionRec != null && transactionRec.TransactionItem__r != null && transactionRec.TransactionItem__r.size() > 0 ){
           
            // Setting the transaction item payload
            for( TransactionItem__c tItem : transactionRec.TransactionItem__r ){
                WrapperUtil.TransactionItemPayload tItemPayload = new WrapperUtil.TransactionItemPayload();
                tItemPayload.keys.TransactionItemID = tItem.Id;
                tItemPayload.values.ItemCost = tItem.Item_Cost__c;
                tItemPayload.values.ItemName = tItem.Name;
                lstTransactionItemPayload.add( tItemPayload );
            }

            try{                  
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
      
                request.setEndpoint( 'callout:Transaction_Item_Api_Credentials' );
                request.setMethod( 'POST' );
                request.setBody( JSON.serialize( lsttransactionItemPayload ) );
                                     
                response = http.send( request );
                String sJson = response.getBody();

                if( response.getStatusCode() == 200 ){
                    TransactionIntegrationBatch.sendTransactionDataToERP( transactionRec );
                }else{
                    Transaction__c trans = new Transaction__c( Id = transactionRec.Id );
                    trans.Integration_Status__c = 'Failed';
                    update trans;
                }
                return response;            
            }catch (Exception ex) {         
                WrapperUtil.LogWrapper logWrap = new WrapperUtil.LogWrapper();
                logWrap.className = 'TransactionIntegrationBatch';
                logWrap.methodName = 'sendTransactionItemData';
                logWrap.message = 'Error: ' + ex.getMessage() + 'LN: ' + ex.getLineNumber();

                LogUtility.createLog( logWrap, true );        

                Transaction__c trans = new Transaction__c( Id = transactionRec.Id );
                trans.Integration_Status__c = 'Failed';
                trans.Error_Message__c = ex.getMessage();
                update trans;
            }
        }
        return null;
    }

    /**********************************************************************************************
    * @Description  : Method to send Transaction Detais to ERP
    * @Params       : Transaction__c transactionRec => transaction record 
    * @Return       : HttpResponse
    **********************************************************************************************/
    public static HttpResponse sendTransactionDataToERP( Transaction__c transactionRec ){
        WrapperUtil.TransactionPayload transactionPayload = new WrapperUtil.TransactionPayload();

        if( transactionRec != null ){

            // Setting the transaction payload
            transactionPayload.keys.TransactionID = transactionRec.Id;
            transactionPayload.values.TotalCost = transactionRec.Total_Cost__c;
            transactionPayload.values.TotalDiscount = transactionRec.Total_Discount__c;
            transactionPayload.values.TransactionDate = transactionRec.Transaction_Date__c;
            transactionPayload.values.TotalCount = transactionRec.Transaction_Count__c;

            try{                  
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                Http http = new Http();
      
                request.setEndpoint( 'callout:Transaction_Api_Credentials' );
                request.setMethod( 'POST' );
                request.setBody( JSON.serialize( transactionPayload ) );
                                     
                response = http.send( request );
                String sJson = response.getBody();

                if( response.getStatusCode() == 200 ){
                    Transaction__c trans = new Transaction__c( Id = transactionRec.Id );
                    trans.Integration_Status__c = 'Success';
                    update trans;
                }else{
                    Transaction__c trans = new Transaction__c( Id = transactionRec.Id );
                    trans.Integration_Status__c = 'Failed';
                    update trans;
                }
                return response;            
            }catch (Exception ex) {         
                WrapperUtil.LogWrapper logWrap = new WrapperUtil.LogWrapper();
                logWrap.className = 'TransactionIntegrationBatch';
                logWrap.methodName = 'sendTransactionDataToERP';
                logWrap.message = 'Error: ' + ex.getMessage() + 'LN: ' + ex.getLineNumber();

                LogUtility.createLog( logWrap, true );   
                
                Transaction__c trans = new Transaction__c( Id = transactionRec.Id );
                trans.Integration_Status__c = 'Failed';
                trans.Error_Message__c = ex.getMessage();
                update trans;
            }
        }
        return null;
    }
}