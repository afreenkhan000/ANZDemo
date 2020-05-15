public abstract class TriggerHandler {
    
    public  abstract void beforeInsert(List<SObject> newItems);
    public  abstract void beforeUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap,List<Sobject> oldItems, Map<Id, SObject> oldItemsMap);
    public  abstract void beforeDelete(List<SObject> oldItems ,Map<Id, SObject> oldItemsMap);
    
    public  abstract void afterInsert(List<SObject> newItems, Map<Id, SObject> newItemsMap);
    public  abstract void afterUpdate(List<SObject> newItems, Map<Id, SObject> newItemsMap,List<Sobject> oldItems, Map<Id, SObject> oldItemsMap);
    public  abstract void afterDelete(List<SObject> oldItems ,Map<Id, SObject> oldItemsMap);
    public  abstract void afterUndelete(Map<Id, SObject> oldItemsMap);

}