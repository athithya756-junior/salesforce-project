public class PublishPlatformEventCallback implements EventBus.EventPublishSuccessCallback,EventBus.EventPublishFailureCallback {
    public void onSuccess(EventBus.SuccessResult result){
        List<String> EventUUILDList = result.getEventUuids();
        insertTask(EventUUILDList,true);
    }
    
    public void onFailure(EventBus.FailureResult result){
        List<String> EventUUILDList = result.getEventUuids();
        insertTask(EventUUILDList,false);
    }

    public void insertTask(List<String> EventUUILDList, Boolean isSuccess){
		String EventUUIDString = '';
        for(String EventUUID : EventUUILDList){
            EventUUIDString = EventUUIDString + EventUUID + '';
        }
        Task taskDetail = new Task();
        if(isSuccess == true){
            //if Platform event publish successfully
			taskDetail.Subject = 'Platform event published Successfully';
            taskDetail.Description = 'Total Platform Events Publish Success ' + EventUUILDList.size() + 'List of event UUID published' + EventUUIDString;
        }else{
           //if Platform event publish failed 
           taskDetail.Subject = 'Platform event published Failed';
            taskDetail.Description = 'Total Platform Events Publish Failed' + EventUUILDList.size() + 'List of event UUID published' + EventUUIDString;
        }
        taskDetail.ActivityDate = Date.today();
		User userDetail = [Select id from User where username = 'athithya756.b31858d912ce@agentforce.com'];
        taskDetail.OwnerId = userDetail.Id;

        try{
            insert taskDetail;
        }catch (Exception ex){
            system.debug('Task Insertion Failed' + ex.getMessage());
        }
    }
}