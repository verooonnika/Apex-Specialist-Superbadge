@isTest
public class WarehouseSyncScheduleTest {
    
    @isTest 
    public static void WarehouseScheduleTest(){
        String cronExp = '00 00 01 * * ?';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String expectedJob = System.schedule('Test Schedule', cronExp, new WarehouseSyncSchedule());
        Test.stopTest();
        CronTrigger actualJob = [SELECT Id FROM CronTrigger where NextFireTime > today];
        System.assertEquals(expectedJob, actualJob.Id);        
    }
}