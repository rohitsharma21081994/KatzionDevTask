/**********************************************************************************************************************
* Name               : TestDataFactory
* Description        : Data factory to create data for all test classes
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
@isTest
public class TestDataFactory {

    /**********************************************************************************************
    * @Description  : Method to create transaction record
    * @Params       : Boolean isInsert
    * @Return       : Transaction__c
    **********************************************************************************************/
    public static Transaction__c createTransaction(  Boolean isInsert ){
        Transaction__c trans = new Transaction__c();
        if( isInsert ){
            insert trans;
        }
        return trans;
    }

    /**********************************************************************************************
    * @Description  : Method to create transaction item record
    * @Params       : Boolean isInsert
    * @Return       : TransactionItem__c
    **********************************************************************************************/
    public static TransactionItem__c createTransactionItem( String transactionId, Boolean isInsert ){
        TransactionItem__c transItem = new TransactionItem__c();
        transItem.Transaction__c = transactionId;
        if( isInsert ){
            insert transItem;
        }
        return transItem;
    }
}


