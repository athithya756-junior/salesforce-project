public with sharing class SubscribePlatformEvent {
	public Static void afterInsert(List<Order_Details__e> orderDetailPlatformEventList){
		List<task> taskList = new List<task>();
    	User adminUser = [Select id from User Where username = 'athithya756.b31858d912ce@agentforce.com'];
        for(Order_Details__e orderDetail : orderDetailPlatformEventList){
            Task taskData = new Task();
            taskData.Subject = 'Platform Event Subscribed Using Trigger';
			taskData.Description = orderDetail.Order_Number__c;
            taskData.OwnerId = adminUser.id;
            taskData.ActivityDate = date.Today();
            taskList.add(taskData);
        }

        if(!taskList.isEmpty()){
            try{
                insert taskList;
            }catch(Exception ex){
                system.debug('Task Creartion Failed' + ex.getMessage());
            }
        }
	}
}