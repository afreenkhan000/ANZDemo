/**
 * Description: This class is used to to build  and process Account Provisione request and response from 3rd party
 * 
 * */

public class AccountProvisionService {
    
    public void sendAccountDetails(FinServ__FinancialAccount__c financialAccount, Integer count){  
        ApiGateway gateway = new ApiGateway();
        
        string requestBody = generateRequestBody(financialAccount);
        System.debug(requestBody);
        HttpResponse resp = gateway.sendRequest('POST', 'randomEndpoint', requestBody, count);
        MockResponse response = (MockResponse)Json.deserialize(resp.getBody(), MockResponse.class);
        
        if(resp.getStatusCode() == 200){
            FinServ__FinancialAccount__c fa = new FinServ__FinancialAccount__c(Id = financialAccount.Id, FinServ__FinancialAccountNumber__c = response.AccountNumber);
            try{ 
                update fa;
            }catch(Exception e){
                    //either I will throw the exception
            //or Put the error logging framewrk to log the exception
            //or use a status field to signify the failed provisioning
             }
 
        }else{
            //either I will throw the exception
            //or Put the error logging framewrk to log the exception
            //or use a status field to signify the failed provisioning
        }
    }
    
    public String generateRequestBody(FinServ__FinancialAccount__c financialAccount){
        RequestBody request = new RequestBody();
        request.customerNumber = financialAccount.FinServ__PrimaryOwner__r.FinServ__CustomerID__c;
        request.accountType = financialAccount.RecordType.Name;
        
        return JSON.serialize(request);
    }
    
    private class RequestBody{
        //public String FinancialAccountId;
        public String customerNumber;
        public String accountType;
    }
}