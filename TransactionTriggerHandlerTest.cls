/**********************************************************************************************************************
* Name               : TransactionTriggerHandlerTest
* Description        : Test class for TransactionTriggerHandler
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
@isTest
public class TransactionTriggerHandlerTest {
    
    @isTest
    public static void reSendTransectionItemToERPTest(){
        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        List< TransactionItem__c > lstTransactionItem = new List< TransactionItem__c >();
        for( Integer i=0; i<2; i++ ){
            TransactionItem__c transItemObj = TestDataFactory.createTransactionItem( transObj.Id, false );
            lstTransactionItem.add( transItemObj );
        }
        insert lstTransactionItem;

        Test.startTest();
        transObj.Integration_Status__c = 'Resend';
        update transObj;
        Test.stopTest();

        system.assertequals( 'Resend', transObj.Integration_Status__c );
    }

    @isTest
    public static void deleteTest(){
        Transaction__c transObj = TestDataFactory.createTransaction( false );
        transObj.Transaction_Count__c  = 2;
        insert transObj;

        Test.startTest();
        delete transObj;
        Test.stopTest();

        List< Transaction__c > lstTransaction = [ SELECT Id FROM Transaction__c ];
        system.assertequals( 0, lstTransaction.size() );
    }
}
