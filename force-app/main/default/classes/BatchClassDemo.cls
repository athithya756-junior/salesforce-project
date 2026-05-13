public with sharing class BatchClassDemo implements Database.Batchable<sObject>,Database.RaisesPlatformEvents{
 
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select id,name from account where Industry = \'Energy\'');
    }

    public void execute(Database.BatchableContext bc,List<Account> accList){
        for(Account acc : accList){
            acc.Name = null; //exception will occur
        }
        
        update accList;
    }

    public void finish(Database.BatchableContext bc){
        system.debug('Batch Class Completed');
    }
}