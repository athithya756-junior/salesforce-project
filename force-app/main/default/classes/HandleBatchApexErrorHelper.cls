public class HandleBatchApexErrorHelper {
	
    public static void afterInsert(List<BatchApexErrorEvent> errorEventList){
        Set<Id> asyncApexJobIdSet = new Set<Id>();
        for(BatchApexErrorEvent batchApexError : errorEventList){
            asyncApexJobIdSet.add(batchApexError.AsyncApexJobId);
        }

		Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>([Select id,ApexClass.Name from AsyncApexJob where id in :asyncApexJobIdSet]);
        List<Task> taskList = new List<Task>();

        for(BatchApexErrorEvent evt : errorEventList){
            AsyncApexJob jobdata = jobs.get(evt.AsyncApexJobId);
            String apexClassName = jobdata.ApexClass.Name;
            if(apexClassName == 'BatchClassDemo'){
                for(String item : evt.JobScope.split(',')){
                    Task taskRecord = new Task();
                    taskRecord.WhatId = (Id) item;
					taskRecord.Subject = evt.ExceptionType;
                    taskRecord.Description = 'Error Logged by BatchClassForDemo';
                    taskList.add(taskRecord);
                }
            }
        }
        try{
            insert taskList;
        }catch(Exception ex){
            System.debug('Exception while creating task' + ex.getMessage());
        }
    }
}