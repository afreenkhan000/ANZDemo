/** Sample Request
 * {  "transType":"Debit",
 * 	"financialAccountId":"29452",
     "transId":"Ref12345",
     "amt":100.00
	 "transStatus" : "Completed",
    }
 * */  

@RestResource(urlMapping='/createFinancialTransactions/*')
global class ReceiveTransactions {
    
    //Transaction volumes were not specified. So assumption was made that it is low
    //If the volume is high and within manageable limits of Rest API then Composite resources can be used to minimize te round trips intead of ApexRest.
    
    @HttpPost
    global static Id createTransactions(String transType, Decimal amt, String financialAccountId, String transId, String transStatus ) {
       try{  
        List<FinServ__FinancialAccountTransaction__c> transactions = [Select Id, FinServ__TransactionStatus__c, FinServ__FinancialAccount__r.FinServ__Balance__c From FinServ__FinancialAccountTransaction__c where FinServ__TransactionId__c =: transId  ];
        System.debug('financialAccountId' +financialAccountId );
        FinServ__FinancialAccount__c fa = [Select Id, FinServ__Balance__c  from FinServ__FinancialAccount__c where FinServ__FinancialAccountNumber__c = :financialAccountId];

		//If transaction exists , then if the Status is already Completed then Just Update the record with details
        //If transaction exists , and if the new status is Completed and existing is not then update the records and also transaction Calc
        //If transactiondoes not exists , and status is Completed then insert and transaction Calculation
        //if transaction does not exists, and status is not Completed then just insert  
                
        FinServ__FinancialAccountTransaction__c trans;
       
        if(transactions.size() >0){
            trans = transactionRecord(transType, amt, fa.Id, transId, transStatus, transactions[0].Id);
            update trans; 
            
            if(transactions[0].FinServ__TransactionStatus__c != 'Completed' && transStatus == 'Completed'){
                //update the balance 
                performBalanceCalculation(transactions[0].FinServ__FinancialAccount__c, amt, transType,transactions[0].FinServ__FinancialAccount__r.FinServ__Balance__c);
            }
            
        }else{
            trans =  transactionRecord(transType, amt, fa.Id, transId, transStatus, null);
            insert trans;
            
            if( transStatus == 'Completed'){
                //update the balance 
                performBalanceCalculation(fa.Id, amt, transType,fa.FinServ__Balance__c);
            }
        }
             return trans.id;
        }catch(Exception e){
            return null;
            //Either I will throw exception;
            // or use Error logging framework for better handling
            // In this scenarion it will fail silently. I would rather prefer to have no Try/catch than failign silently.
        }
        
    }
    
    public static FinServ__FinancialAccountTransaction__c transactionRecord(String transType, Decimal amt, String financialAccountId, String transId, String transStatus, Id transSFId){
        FinServ__FinancialAccountTransaction__c trans = new FinServ__FinancialAccountTransaction__c();
        trans.FinServ__Amount__c   			= amt;
        trans.FinServ__FinancialAccount__c 	= financialAccountId;
        trans.FinServ__TransactionId__c 	= transId;
        trans.FinServ__TransactionType__c 	= transType;
        trans.FinServ__TransactionStatus__c = transStatus;
        trans.FinServ__TransactionDate__c   = DateTime.now();
        if(transId != null){
          trans.Id   						= transSFId;
        }
        return trans;
    }
    
    public static void performBalanceCalculation(String financialAccountId, Decimal amt, String transactionType, Decimal balance){
       
        FinServ__FinancialAccount__c fAcct = new FinServ__FinancialAccount__c();
        fAcct.Id = financialAccountId;
        
        if(balance== null){
            balance =0;
        }
        
        if(transactionType == 'Debit'){
            fAcct.FinServ__Balance__c = balance - amt;
        }else if(transactionType == 'Credit'){
            fAcct.FinServ__Balance__c = balance + amt;
        }
        
        update fAcct;
    }
    
}