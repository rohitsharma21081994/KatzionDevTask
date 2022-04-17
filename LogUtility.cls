/**********************************************************************************************************************
* Name               : LogUtility
* Description        : Utility class to write generic / reusable methods to create logs
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
public class LogUtility {

    /**********************************************************************************************
    * @Description  : Method to create log records
    * @Params       : WrapperUtil.LogWrapper logWrap => Wrapper class for log details
    * @Params       : Boolean doDML => boolean flag for DML
    * @Return       : Log__c
    **********************************************************************************************/
    public static Log__c createLog( WrapperUtil.LogWrapper logWrap, Boolean doDML ){
        Log__c log = new Log__c();
        log.Class_Name__c = logWrap.className;
        log.Method_Name__c = logWrap.methodName;
        log.Message__c = logWrap.message;
        
        // Log request fields
        if( logWrap.request != null ){
            log.Request_Body__c = logWrap.request.getBody().abbreviate( 32768 );
            log.Request_Endpoint__c = logWrap.request.getEndpoint();
        }
        
        // Log response fields
        if( logWrap.response != null ){
            log.Response_Status_Code__c = logWrap.response.getStatusCode();
            log.Response_Status_Message__c = logWrap.response.getStatus();
            log.Response_Body__c = logWrap.response.getBody().abbreviate( 32768 );
            
            String headers = '';
            for( String thisHeaderKey : logWrap.response.getHeaderKeys() ) {
                headers = headers + thisHeaderKey + ': ' + logWrap.response.getHeader( thisHeaderKey ) + '\n';
            }
            log.Response_Headers__c = headers.abbreviate( 32768 );
        }
        
        if( doDML ) {
            try{
                insert log;
            }catch( Exception e ) {
				system.debug( 'Unable to create log record.' );
			}
        }
        return log;
    }
}