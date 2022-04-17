/**********************************************************************************************************************
* Name               : TransactionItemTriggerHandlerTest
* Description        : Test class for TransactionItemTriggerHandler
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
@isTest
public class TransactionItemTriggerHandlerTest {
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
        
        Test.startTest();
        insert lstTransactionItem;
        Test.stopTest();
    }
    
    @isTest
    public static void updateTest(){
        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj.Id, true );
        transItemObj.Item_Cost__c = 10;
        
        Test.startTest();
        update transItemObj;
        Test.stopTest();
    }

    
    @isTest
    public static void deleteTest(){
        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj.Id, true );

        Test.startTest();
        delete transItemObj;
        Test.stopTest();

        List< TransactionItem__c > lstTransactionItem = [ SELECT Id FROM TransactionItem__c ];
        system.assertequals( 0, lstTransactionItem.size() );
    }
}
