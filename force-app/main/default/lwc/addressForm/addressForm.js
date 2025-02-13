import { LightningElement, api } from 'lwc';
import { generateRandomAddress } from 'c/randomAddressGenerator';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import STREET_FIELD from '@salesforce/schema/Venue__c.Street__c';
import CITY_FIELD from '@salesforce/schema/Venue__c.City__c';
import STATE_FIELD from '@salesforce/schema/Venue__c.State__c';
import POSTCODE_FIELD from '@salesforce/schema/Venue__c.PostalCode__c';
import COUNTRY_FIELD from '@salesforce/schema/Venue__c.Country__c';
export default class AddressForm extends LightningElement {
    address = null;
    @api recordId;
    isLoading = false;
    fields = [
        STREET_FIELD, CITY_FIELD, STATE_FIELD, POSTCODE_FIELD, COUNTRY_FIELD
    ]
    async handleGenerateAddress() {
        this.isLoading = true;
        this.address = await generateRandomAddress();
        await this.updateAddress(this.address);
        this.isLoading = false;
    }
    async updateAddress(newAddress) {
        const fields = {
            Id: this.recordId,
            Street__c : newAddress.street_address,
            City__c : newAddress.city,
            State__c : newAddress.state,
            Country__c : newAddress.country,
            PostalCode__c : newAddress.postcode,
            Location__Latitude__s : newAddress.latitude,
            Location__Longitude__s : newAddress.longitude
        };

        const recordInput = { fields };

        try {
            await updateRecord(recordInput);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Address updated successfully',
                    variant: 'success'
                })
            );
        } catch (error) {
            // Show error message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }
}