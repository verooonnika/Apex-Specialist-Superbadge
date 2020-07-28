public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> updatedRequests) {
        
        List<case> newRequests = new List<Case>();
        
        Map<Id,Integer> dueDays = getDueDate(updatedRequests);
        for(Case closedRequest: updatedRequests){
            if((closedRequest.type == 'Repair' || closedRequest.type == 'Routine Maintenance') && closedRequest.status == 'Closed'){
                Case newRequest = new Case();
                newRequest.Vehicle__c = closedRequest.Vehicle__c;
                newRequest.Equipment__c = closedRequest.Equipment__c;
                newRequest.Type = 'Routine Maintenance';
                newRequest.Subject = closedRequest.Subject;
                newRequest.Date_Reported__c = Date.today();
                if(dueDays.get(closedRequest.Id)!=null){
                    newRequest.Date_Due__c=Date.today()+dueDays.get(closedRequest.Id);
                }
                else{
                    newRequest.Date_Due__c=Date.today();
                }
                newRequests.add(newRequest);
            }
            
        }   
        insert newRequests;
    }     
    
    public static  Map<Id, Integer> getDueDate(List<Case> requests){
        Map<Id, Integer> result = new Map<Id, Integer>();
        Map<Id, Case> caseKeys = new Map<Id, Case> (requests);
        List<AggregateResult> res = [SELECT Maintenance_Request__r.Id, min(Equipment__r.Maintenance_Cycle__c)cycle
                                     FROM Work_Part__c
                                     WHERE Maintenance_Request__r.Id in :caseKeys.keySet()
                                     GROUP BY Maintenance_Request__r.Id ];
        
        for(AggregateResult r : res){
            result.put(r.Id, Integer.valueOf(r.get('cycle')));
        }
        return result;  
    }
    
}