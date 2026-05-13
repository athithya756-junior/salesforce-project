trigger HandleBatchApexError on BatchApexErrorEvent (after insert) {
    if(trigger.isAfter && Trigger.isInsert){
        HandleBatchApexErrorHelper.afterInsert(trigger.new);
    }
}