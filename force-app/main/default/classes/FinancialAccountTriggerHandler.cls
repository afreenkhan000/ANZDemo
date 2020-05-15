public class FinancialAccountTriggerHandler extends TriggerHandler {
    
    public  override void beforeInsert(List<SObject> newItems){
        
    }
    
    public  override void beforeUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap,List<Sobject> oldItems, Map<Id, SObject> oldItemsMap){
        
    }
    
    public  override void beforeDelete(List<SObject> oldItems ,Map<Id, SObject> oldItemsMap){
        
    }
    
    public  override void afterInsert(List<SObject> newItems, Map<Id, SObject> newItemsMap){
        //Call the third party to get the Financial Account Number 
        provisionFinAcct(newItems);
        
    }
    
    public  override void afterUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap,List<Sobject> oldItems, Map<Id, SObject> oldItemsMap){
        
    }
    
    public  override void afterDelete(List<SObject> oldItems ,Map<Id, SObject> oldItemsMap){
        
    }
    
    public  override void afterUndelete(Map<Id, SObject> oldItemsMap){
        
    }
    
    
    public static void provisionFinAcct(List<SObject> newItems){
        list<FinServ__FinancialAccount__c> faList  = (list<FinServ__FinancialAccount__c>)newItems;
        Set<Id> fAcctIdSet = new Set<Id>();
        for(FinServ__FinancialAccount__c fAccount: faList){
            fAcctIdSet.add(fAccount.Id);
        }
        generateFinAcctNumber(fAcctIdSet);
    }
    
    @future(callout=true)
    public static void generateFinAcctNumber(Set<Id> fAcctIdSet){
        AccountProvisionService serv = new AccountProvisionService();
        Map<Id, FinServ__FinancialAccount__c> fAccountMap = new Map<Id, FinServ__FinancialAccount__c>([Select Id,RecordType.Name,FinServ__PrimaryOwner__c, FinServ__PrimaryOwner__r.FinServ__CustomerID__c From FinServ__FinancialAccount__c Where Id in :fAcctIdSet ]);

        //Assuming the end point is not bulkified and sending details one by one. 
        //As volume is not mentioned, which will drive the number of call out calculation, therfore going with this approach.
        Integer count = 1; //Adding counter to be used in unique Account Number gerenation logic later
        for(Id accId : fAcctIdSet ){
            if(fAccountMap.containsKey(accId)){
                serv.sendAccountDetails(fAccountMap.get(accId), count);
            }
            count ++;
        }
        
    }
}