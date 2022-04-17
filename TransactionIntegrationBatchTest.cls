/**********************************************************************************************************************
* Name               : TransactionIntegrationBatchTest
* Description        : Test class for TransactionIntegrationBatch
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
@isTest
public class TransactionIntegrationBatchTest {
 
    @isTest
    public static void executeTestPositive(){

        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        List< TransactionItem__c > lstTransactionItem = new List< TransactionItem__c >();
        for( Integer i=0; i<2; i++ ){
            TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj.Id, false );
            lstTransactionItem.add( transItemObj );
        }
        insert lstTransactionItem;

        // Set mock callout class 
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseGenerator() );

        TransactionIntegrationBatch bc1 = new TransactionIntegrationBatch();

        Set< Id > setransIds = new Set< Id > { transObj.Id };
        TransactionIntegrationBatch bc = new TransactionIntegrationBatch( setransIds );
        
        Test.startTest();
        database.executeBatch( bc, 1 );
        Test.stopTest();
    }

    @isTest
    public static void executeTestNegative(){

        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        List< TransactionItem__c > lstTransactionItem = new List< TransactionItem__c >();
        for( Integer i=0; i<2; i++ ){
            TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj.Id, false );
            lstTransactionItem.add( transItemObj );
        }
        insert lstTransactionItem;

        Transaction__c transObj1 = TestDataFactory.createTransaction( false );
        transObj1.Transaction_Count__c  = 2;
        insert transObj1;

        List< TransactionItem__c > lstTransactionItem1 = new List< TransactionItem__c >();
        for( Integer i=0; i<2; i++ ){
            TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj1.Id, false );
            lstTransactionItem1.add( transItemObj );
        }
        insert lstTransactionItem1;

        // Set mock callout class 
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseGenerator() );

        TransactionIntegrationBatch bc1 = new TransactionIntegrationBatch();

        Set< Id > setransIds = new Set< Id > { transObj.Id, transObj1.Id };
        TransactionIntegrationBatch bc = new TransactionIntegrationBatch( setransIds );
        
        Test.startTest();
        database.executeBatch( bc, 2 );
        Test.stopTest();
    }
   
    @isTest
    public static void sendTransectionItemToERPTest(){

        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        List< TransactionItem__c > lstTransactionItem = new List< TransactionItem__c >();
        for( Integer i=0; i<2; i++ ){
            TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj.Id, false );
            lstTransactionItem.add( transItemObj );
        }
        insert lstTransactionItem;

        List< Transaction__c > lstTransRec = [ SELECT Id, Total_Cost__c, Total_Discount__c, Transaction_Date__c, Transaction_Count__c,
                                                ( SELECT Id, Name, Item_Cost__c, Item_Discount__c FROM TransactionItem__r  )
                                                FROM Transaction__c  ];
        
        // Set mock callout class 
        Test.setMock( HttpCalloutMock.class, new MockHttpResponseGenerator() );

        Test.startTest();
        HttpResponse response = TransactionIntegrationBatch.sendTransactionItemDataToERP( lstTransRec[0] );
        Test.stopTest();
    }
    
}
