@isTest
public class FinancialAccountTriggerHandlerTest {
    
    @testSetup Static void createTestData(){
        Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account cust =  new Account (RecordTypeId = accRecType,
                                     Salutation = 'Ms.',
                                     FirstName = 'Sara',
                                     LastName  = 'Tencredi'
                                    );
        insert cust;
      
     }
    
    public static testmethod void testPositiveProvisioning(){
        Account acct = [Select Id, FinServ__CustomerID__c From Account Limit 1];
        
        System.assert(String.isNotBlank(acct.FinServ__CustomerID__c) ,  'Customer has Account Number');
        
        Test.startTest();
        Id fsAccRecType = Schema.SObjectType.FinServ__FinancialAccount__c.getRecordTypeInfosByName().get('Savings Account').getRecordTypeId();
 		FinServ__FinancialAccount__c fsAcc = new FinServ__FinancialAccount__c ( FinServ__PrimaryOwner__c = acct.Id ,
                                                                               	RecordTypeId = fsAccRecType,
                                                                                Name = 'Test Savings Account',
                                                                                FinServ__FinancialAccountType__c = 'Savings',
                                                                                FinServ__Balance__c = 10000
                                                                              	); 
        insert fsAcc;
        Test.stopTest();
        
        FinServ__FinancialAccount__c fsAccAfter = [select Id ,FinServ__FinancialAccountNumber__c from FinServ__FinancialAccount__c where Id = :fsAcc.Id];
                        
        
        system.assert(!String.isBlank(fsAccAfter.FinServ__FinancialAccountNumber__c), 'Account provisioned');
    }
    
    public static testmethod void testNegativeProvisioning(){
        //As the exception scenario was not specified and because of the multiple solution option we can go with (specified in the AccountProvisionService)
        // Therefore leaving this method blank
    }
    
    
}