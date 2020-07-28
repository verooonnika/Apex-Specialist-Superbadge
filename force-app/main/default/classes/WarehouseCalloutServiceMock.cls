public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    
     public HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"_id":"42084298h2aaf741","replacement":false,"quantity":2,"name":"testName","maintenanceperiod":365,"lifespan":420,"cost":1000,"sku":"5543"}]');
        response.setStatusCode(200);
        return response;
    }
}