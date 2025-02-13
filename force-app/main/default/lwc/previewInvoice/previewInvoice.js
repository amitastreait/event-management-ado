import { api, LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import generatePDF from '@salesforce/apex/InvoiceController.generatePDF';
import saveAndEmailPDF from '@salesforce/apex/InvoiceController.saveAndEmailPDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PreviewInvoice extends LightningElement {
    @api recordId;
    @api objectApiName;
    isLoading = false;

    @wire(CurrentPageReference)
    getRecordIdFromUrl(currentPageReference) {
        console.log(currentPageReference)
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

    get pdfUrl() {
        return `/apex/Invoice?id=${this.recordId}`;
    }

    close(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    savePdf(event){
        event.preventDefault();
        this.isLoading = true;
        generatePDF({
            invoiceId : this.recordId
        })
        .then(result => {
            console.log(result);
            this.showToastMessage('Success', 'Invoice has been saved successfully', 'success');
            this.close();
        })
        .catch(error => {
            console.error(error);
            this.showToastMessage('Error', error.body.message, 'error');
        })
        .finally(() => {
            this.isLoading = false;
        });
    }
    saveAndEmail(event){
        event.preventDefault();
        this.isLoading = true;
        saveAndEmailPDF({
            invoiceId : this.recordId
        })
        .then(result => {
            console.log(result);
            this.showToastMessage('Success', 'Invoice has been saved and emailed successfully', 'success');
            this.close();
        })
        .catch(error => {
            console.error(error);
            this.showToastMessage('Error', error.body.message, 'error');
        })
        .finally(() => {
            this.isLoading = false;
        })
    }

    /** Create a Method to display the toast message */
    showToastMessage(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}