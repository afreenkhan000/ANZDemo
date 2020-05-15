trigger FinanicalAccountTrigger on FinServ__FinancialAccount__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	
    FinancialAccountTriggerHandler handler = new FinancialAccountTriggerHandler();   
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.beforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.afterInsert(Trigger.new,Trigger.newMap);
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.beforeUpdate(Trigger.new,Trigger.newMap,trigger.old,trigger.oldMap); 
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
         handler.afterUpdate(Trigger.new,Trigger.newMap,trigger.old,trigger.oldMap); 
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
        handler.beforeDelete(Trigger.old, Trigger.newMap);
    }
    else 
        if(Trigger.isDelete && Trigger.isAfter){
         handler.afterDelete(Trigger.old, Trigger.oldMap);
    }
}