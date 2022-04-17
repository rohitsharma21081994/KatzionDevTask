/**********************************************************************************************************************
* Name               : WrapperUtil
* Description        : Utility class to create wrappers
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
public class WrapperUtil {

    /**********************************************************************************************
    * @Description  : Wrapper to be used to log error or exception in log object
    **********************************************************************************************/
    public class LogWrapper{
        public string className {get; set;}
        public string methodName {get; set;}
        public HttpRequest request {get; set;}
        public HttpResponse response {get; set;}
        public string message {get; set;}
    }
    
    /**********************************************************************************************
    * @Description  : Wrapper to create payload for Transaction Item API call
    **********************************************************************************************/
    public class TransactionItemPayload{
		public TransactionItemPayloadKeys keys {get; set;}
		public TransactionItemPayloadValues values {get; set;}
        
        public TransactionItemPayload(){
            this.keys = new TransactionItemPayloadKeys();
            this.values = new TransactionItemPayloadValues();
        }
    }
    
    /**********************************************************************************************
    * @Description  : Wrapper to create payload for Transaction Item API call
    **********************************************************************************************/
    public class TransactionItemPayloadKeys {
		public String TransactionItemID {get; set;}
	}
    
    /**********************************************************************************************
    * @Description  : Wrapper to create payload for Transaction Item API call
    **********************************************************************************************/
    public class TransactionItemPayloadValues {
		public Decimal ItemCost {get; set;}
		public String ItemName {get; set;}
	}
    
    /**********************************************************************************************
    * @Description  : Wrapper to create payload for Transaction API call
    **********************************************************************************************/
    public class TransactionPayload{
		public TransactionPayloadKeys keys {get; set;}
		public TransactionPayloadValues values {get; set;}
        
        public TransactionPayload(){
            this.keys = new TransactionPayloadKeys();
            this.values = new TransactionPayloadValues();
        }
    }
    
    /**********************************************************************************************
    * @Description  : Wrapper to create payload for Transaction Item API call
    **********************************************************************************************/
    public class TransactionPayloadKeys {
		public String TransactionID {get; set;}
	}
    
    /**********************************************************************************************
    * @Description  : Wrapper to create payload for Transaction Item API call
    **********************************************************************************************/
    public class TransactionPayloadValues {
		public Decimal TotalCost {get; set;}
		public Decimal TotalDiscount {get; set;}
        public Date TransactionDate {get; set;}
        public Decimal TotalCount {get; set;}
	}
}