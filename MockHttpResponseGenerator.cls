/**********************************************************************************************************************
* Name               : MockHttpResponseGenerator
* Description        : Mock response for api calls
* Created Date       : 17-04-2022
* Created By         : Rohit Sharma
* --------------------------------------------------------------------------------------------------------------------
* Version       Author       Date             Comment                                                                 
* 1.0           Rohit       17-04-2022       Initial Draft    
**********************************************************************************************************************/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}