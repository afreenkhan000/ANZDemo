/**
 * Description: This class is used to do the actual handshake. 
 * */
public class APIGateway {
	
    //As we are mocking the response therefore I did not focus more on the proper endpoint and its authentication mechanism
     public HttpResponse sendRequest(string method, string Endpoint ,string stringBody, Integer count){
        http h 				= new http();
        httpRequest request = new httpRequest();
        request.setMethod(method);
        request.setEndpoint(Endpoint);
        request.setTimeout(120000);
        request.setBody(stringBody);  
      
        httpResponse response = new httpResponse();
                
        response.setBody(generateMockresponse(count));
        response.setStatusCode(200);
        system.debug('resp>>'+response);
        system.debug('respBody:'+response.getBody());
        return response;
    }
    
    public String generateMockresponse(Integer count){
        MockResponse mResponse = new MockResponse();
        mResponse.AccountNumber = generateRandomNumber(count);
        return Json.serialize(mResponse);
    }
    
    public String generateRandomNumber(Integer count){
        Integer multiplier = 10000+count;
        String randUnquieNumber = String.valueOf(Integer.ValueOf(Math.random() * multiplier));
        return randUnquieNumber;
    }
    
}