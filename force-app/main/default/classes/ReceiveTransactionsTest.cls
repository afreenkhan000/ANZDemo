@isTest
public class ReceiveTransactionsTest {
	@testSetup Static void createTestData(){
        Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account cust =  new Account (RecordTypeId = accRecType,
                                     Salutation = 'Ms.',
                                     FirstName = 'Sara',
                                     LastName  = 'Tencredi'
                                    );
        insert cust;
        
        Id fsAccRecType = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('Loan Account').getRecordTypeId();
 		FinServ__FinancialAccount__c fsAcc = new FinServ__FinancialAccount__c ( FinServ__PrimaryOwner__c = cust.Id ,
                                                                               	RecordTypeId = fsAccRecType,
                                                                                Name = 'Test Savings Account',
                                                                                FinServ__Status__c = 'Active',
                                                                                FinServ__FinancialAccountType__c = 'Savings',
                                                                                //FinServ__FinancialAccountNumber__c = '29452',
                                                                                FinServ__Balance__c = 123445.00
                                                                              	); 
        insert fsAcc;
      
     }
    
    //Check incoming Debit with Completed Status
    public static testmethod void testPositiveDebitIncomingTransaction(){
       // String jsonString = '{  "transType":"Debit", "financialAccountId":"29452", "transId":"Ref12345","amt":100.00,"transStatus" : "Completed"}';
    
    FinServ__FinancialAccount__c fa = [Select Id, FinServ__FinancialAccountNumber__c From FinServ__FinancialAccount__c Limit 1];
    System.debug(fa.FinServ__FinancialAccountNumber__c);
    System.assert(fa != null);
        
    Test.startTest();
	Id transId = ReceiveTransactions.createTransactions('Debit', 100,  fa.FinServ__FinancialAccountNumber__c,'Ref12345',  'Completed');
    System.assert(String.isNotBlank(transId));
      //check for Idempotancy
    Id transId2 = ReceiveTransactions.createTransactions('Debit', 100,  fa.FinServ__FinancialAccountNumber__c,'Ref12345',  'Completed');
    System.assert(String.isNotBlank(transId2));
    Test.stopTest();
        
    }
    
    //Check incoming Debit without Completed Status, with no Financial Account in the system
    public static testmethod void testNegativeDebitIncomingTransaction(){
    Test.startTest();
	Id transId = ReceiveTransactions.createTransactions('Debit', 100,  '1234','Ref12345',  'Completed');
    System.assert(String.isBlank(transId));
    
    
    Test.stopTest();
    }
    
    //Check incoming Credit transaction with Completed Status
    public static testmethod void testPositiveCreditIncomingTransaction(){
        FinServ__FinancialAccount__c fa = [Select Id, FinServ__FinancialAccountNumber__c From FinServ__FinancialAccount__c Limit 1];
    System.debug(fa.FinServ__FinancialAccountNumber__c);
    System.assert(fa != null);
        
    Test.startTest();
	Id transId = ReceiveTransactions.createTransactions('Credit', 100,  fa.FinServ__FinancialAccountNumber__c,'Ref12345',  'Completed');
    System.assert(String.isNotBlank(transId));
    Test.stopTest();
    }
    
    //Check incoming Credit transaction with Completed Status
    public static testmethod void testNegativeCreditIncomingTransaction(){
        Test.startTest();
	Id transId = ReceiveTransactions.createTransactions('Credit', 100,  '1234','Ref12345',  'Completed');
    System.assert(String.isBlank(transId));
    Test.stopTest();
    }
    
}