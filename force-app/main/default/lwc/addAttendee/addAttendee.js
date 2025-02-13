import { LightningElement, wire, api, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import addAttendee from '@salesforce/apex/AddAttendeeController.addAttendee';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { generateRandomCandidate } from 'c/randomCandidateGenerator'; // Adjust the import path as needed

export default class AddAttendee extends LightningElement {
    // ABCD000000000000AAA
    @api recordId;
    @api objectApiName;

    @track attendee = {
        name: '',
        email: '',
        phone: '',
        jobTitle: '',
        companyName: '',
        eventId : '',
        tshirtSize : ''
    };

    isLoading = false;

    @track tshirtOptions = [
        { label: 'Small', value: 'S' },
        { label: 'Medium', value: 'M' },
        { label: 'Large', value: 'L' },
        { label: 'X-Large', value: 'XL' },
        { label: 'XX-Large', value: 'XXL' },
        { label: 'XXX-Large', value: 'XXXL' }
    ];

    async handleGenerateCandidate() {
        this.isLoading = true;
        let candidate = await generateRandomCandidate();
        //console.log(`Candidate Data ${JSON.stringify(candidate)}`);
        this.attendee.name = candidate.name;
        this.attendee.email = candidate.email;
        this.attendee.phone = candidate.phone;
        this.attendee.jobTitle = candidate.jobTitle;
        this.attendee.companyName = candidate.companyName;
        this.attendee.tshirtSize = candidate.tshirtSize;
        this.isLoading = false;
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            console.log(this.recordId)
        }
    }

    handleInputChange(event){
        event.preventDefault();
        const fieldName = event.target.name;
        const fieldValue = event.target.value;
        this.attendee[fieldName] = fieldValue;
    }

    handleSubmit(event){
        event.preventDefault();
        if(this.handleInputValidate()){
            this.isLoading = true;
            this.attendee.eventId = this.recordId;
            
            addAttendee({ 
                wrapper : this.attendee 
            })
            .then(result => {
                console.log('Result', result);
                this.showAlert('Success', 'Attendee added successfully!', 'success');
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                console.error('Error:', error);
                this.showAlert('Error', JSON.stringify(error), 'error');
            })
            .finally(()=>{
                this.isLoading = false;
            })
        }
    }

    handleInputValidate(){
        const allValid = [
            ...this.template.querySelectorAll('lightning-input, lightning-combobox'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    }

    showAlert(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}