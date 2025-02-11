import { getRecord } from 'lightning/uiRecordApi';
import { api, LightningElement, wire } from 'lwc';
import hasBrowseSolutions from '@salesforce/apex/PermUtils.hasBrowseSolutions';
export default class LdsGetRecord extends LightningElement {

    @api recordId;
    @api objectApiName;

    get fields(){
        if(this.objectApiName === 'Account'){
            return ['Account.Name', 'Account.Type'];
        } else if(this.objectApiName === 'Contact'){
            return ['Contact.Name', 'Contact.Department'];
        }else{
            return [this.sobjectType+'.Id'];
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    wiredData({error, data}){
        if(data){
            console.log('Record Data: ', data);
        }
        else if(error){
            console.log('Error: ', error);
        }
    }

    handleClick(event){
        event.preventDefault();
        hasBrowseSolutions()
        .then(result => {
            console.log('Result', result);
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
}