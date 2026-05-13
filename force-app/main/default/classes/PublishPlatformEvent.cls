public class PublishPlatformEvent {
	
    public Static void PublishPlatformEventDemo(){
        List<Order_Details__e> orderEvents = new List<Order_Details__e>();
        orderEvents.add(new Order_Details__e(Order_Number__c = 'ORD2003',Generate_Invoice__c = false));
        orderEvents.add(new Order_Details__e(Order_Number__c = 'ORD2004',Generate_Invoice__c = false));
        orderEvents.add(new Order_Details__e(Order_Number__c = 'ORD2005',Generate_Invoice__c = false));
        
        //List<Database.SaveResult> results = EventBus.publish(orderEvents);
        
        PublishPlatformEventCallback CI = new PublishPlatformEventCallback();
        List<Database.SaveResult> results = EventBus.publish(orderEvents,CI);

        for(Database.SaveResult result: results){
            if(result.isSuccess()){
                System.debug('Platform Event Published Successfully');
            }else{
                List<Database.error> errList = result.getErrors();
                for(Database.error errorDetail : errList){
                   System.debug('Error Details' + errorDetail.getMessage()); 
                }
            }
        }
    }
}