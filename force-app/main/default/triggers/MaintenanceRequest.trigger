trigger MaintenanceRequest on Case (before update, after update) {
    if(trigger.isAfter){
        MaintenanceRequestHelper.updateWorkOrders(Trigger.New);
    }
}