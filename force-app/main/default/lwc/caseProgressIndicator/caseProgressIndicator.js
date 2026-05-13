import { LightningElement,wire,api } from 'lwc';
import { getObjectInfo,getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord,getFieldValue,updateRecord,notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import CASE_ID from '@salesforce/schema/Case.Id';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } 
    from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseProgressIndicator extends LightningElement {

    @api recordId;

    caseStatus;
    statusOption;

    channelName = "/event/Case_Detail__e";

    subscription = {};

    // get the picklist value for case status
    @wire(getObjectInfo,{objectApiName: CASE_OBJECT})
    objectInfo;

    @wire(getPicklistValues,{recordTypeId : "$objectInfo.data.defaultRecordTypeId",fieldApiName :STATUS_FIELD})
    picklistFunction({data,error}){
        if(data){
            this.statusOption = data.values;
        }else if(error){
            console.log(error);
        }
    }

    // get the current value of case status
    @wire(getRecord,{recordId : '$recordId',fields : [STATUS_FIELD]})
    getRecordOutput({data,error}){
        if(data){
            this.caseStatus = getFieldValue(data,STATUS_FIELD);
        }else if(error){
            console.log(error);
        }
    }

    // Initializes the component
    connectedCallback() {
        this.handleSubscribe();
        // Register error listener
        this.registerErrorListener();
    }

    // Handles subscribe button click
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        //const messageCallback = function (response) {
        //console.log("New message received: ", JSON.stringify(response));
        // Response contains the payload of the new message received
        //};

        const messageCallback = (response) => {
            console.log("New message received: ", JSON.stringify(response));
            this.handleEventResponse(response);
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then((response) => {
        // Response contains the subscription information on subscribe call
        console.log("Subscription request sent to: ", JSON.stringify(response.channel));
        this.subscription = response;
        });
    }

    async handleEventResponse(response){
        console.log("response from apex",JSON.stringify(response));
        if(response.hasOwnProperty('data')){
            let jsonObj = response.data;
            if(jsonObj.hasOwnProperty('payload')){
                let responseCaseId = response.data.payload.Case_Id__c;
                let responseCaseStatus = response.data.payload.Case_Status__c;

                let fields = {};
                fields[CASE_ID.fieldApiName] = responseCaseId;
                fields[STATUS_FIELD.fieldApiName] = responseCaseStatus;

                let recordInput = {fields};
                await updateRecord(recordInput);
                await notifyRecordUpdateAvailable([{recordId : this.recordId}]);
                const event = new ShowToastEvent({
                    title : 'Case update',
                    message : 'Case record updated'
                });
                this.dispatchEvent(event);
            }
            
        }
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log("Received error from server: ", JSON.stringify(error));
            // Error contains the server-side error
        });
    }

    disconnectedCallback(){
        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, (response) => {
            console.log("unsubscribe() response: ", JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

}