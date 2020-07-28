public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(WAREHOUSE_URL);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            List<Object> listResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
            List<Product2> equipmentToUpdate = new List<Product2>();
            for(Object obj : listResponse) {
                Map<String, Object> equipmentMap = (Map<String, Object>)obj;
                Product2 equipment = new Product2();
                equipment.Replacement_Part__c = (Boolean)equipmentMap.get('replacement');
                equipment.Cost__c = (Decimal) equipmentMap.get('lifespan');
                equipment.Current_Inventory__c = (Double) equipmentMap.get('quantity');
                equipment.Lifespan_Months__c = (Integer)equipmentMap.get('lifespan');
                equipment.Maintenance_Cycle__c = (Integer)equipmentMap.get('maintenanceperiod');
                equipment.Warehouse_SKU__c = (String)equipmentMap.get('sku');
                equipment.Name = (String)equipmentMap.get('name');
                equipmentToUpdate.add(equipment);
            }            
            if(equipmentToUpdate.size() > 0){
                upsert equipmentToUpdate;
            }
            
        }
        
    }
}