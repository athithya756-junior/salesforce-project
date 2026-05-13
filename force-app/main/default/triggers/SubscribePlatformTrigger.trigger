trigger SubscribePlatformTrigger on Order_Details__e (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        SubscribePlatformEvent.afterInsert(trigger.new);
    }
}