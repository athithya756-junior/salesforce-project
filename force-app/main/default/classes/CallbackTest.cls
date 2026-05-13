@isTest
public with sharing class CallbackTest {

    @isTest 
    Static void testFailedEvents(){
        Order_Details__e orderDetail = new Order_Details__e();
        orderDetail.Order_Number__c = 'ORD4000';
        orderDetail.Generate_Invoice__c = false;
        
        PublishPlatformEventCallback CI = new PublishPlatformEventCallback();
        EventBus.publish(orderDetail,CI);
		//if we call this method it will automatically invoke this failure method for testing
        Test.getEventBus().fail();
		List<Task> taskList = [Select id,Subject,Description from Task where Subject = 'Platform event published Failed'];
        system.Assert.areEqual(1,taskList.size(),'Task Creation Failed');
    }
    
    @isTest 
    Static void testSuccessEvents(){
        Order_Details__e orderDetail = new Order_Details__e();
        orderDetail.Order_Number__c = 'ORD5000';
        orderDetail.Generate_Invoice__c = false;
        
        PublishPlatformEventCallback CI = new PublishPlatformEventCallback();
        Test.startTest();
        EventBus.publish(orderDetail,CI);
		Test.stopTest();
		List<Task> taskList = [Select id,Subject,Description from Task where Subject = 'Platform event published Successfully'];
        system.Assert.areEqual(1,taskList.size(),'Task Creation Failed');
    }
}