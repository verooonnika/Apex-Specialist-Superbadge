@isTest
public class MaintenanceRequestTest {
    
    @isTest 
    public static void testMaintenanceRequest(){
        
        List<Case> requestsToInsert = new List<Case>();
        Product2 equipment = new Product2(Name = 'testEquipment',
                                          Maintenance_Cycle__c = 2,
                                          Replacement_Part__c = true);
        insert equipment;
        
        Vehicle__c vehicle = new Vehicle__c(Name = 'testVehicle');
        insert vehicle;
        
        for(Integer i = 0; i < 300; i++){
            Case request = new Case(description = 'testRequest',
                                    Subject = 'testSubject',
                                    Type = 'Repair',
                                    Status = 'Working',
                                    origin = 'Web',
                                    Date_Reported__c = date.today(),
                                    Date_Due__c = date.today(),
                                    Vehicle__c = vehicle.Id,
                                    Equipment__c = equipment.Id);
            requestsToInsert.add(request);
        }
        insert requestsToInsert;
        
        Work_Part__c workPart = new Work_Part__c(Equipment__c = equipment.Id,
                                                 Maintenance_Request__c = requestsToInsert[0].id); // for testing Maintanence cycle == null
        insert workPart;
        
        for(Case request: requestsToInsert){
            request.Status = 'Closed';
        }
        update requestsToInsert;
        
        System.assertEquals(300, [SELECT count() FROM Case WHERE Type = 'Routine Maintenance']);
    }
    
    @isTest
    public static void testNegativeCase(){
        
        Product2 equipment = new Product2(Name = 'testEquipment',
                                          Maintenance_Cycle__c = 2,
                                          Replacement_Part__c = true);
        insert equipment;
        
        Vehicle__c vehicle = new Vehicle__c(Name = 'testVehicle');
        insert vehicle;
        
        Case request = new Case(description = 'testRequest',
                                Subject = 'testSubject',
                                Type = 'Repair',
                                Status = 'Working',
                                origin = 'Web',
                                Date_Reported__c = date.today(),
                                Date_Due__c = date.today(),
                                Vehicle__c = vehicle.Id,
                                Equipment__c = equipment.Id);
        insert request;
        
        request.Status = 'New';
        update request;
        
        System.assertEquals(0, [SELECT count() FROM Case WHERE Type = 'Routine Maintenance']);   
    }
}