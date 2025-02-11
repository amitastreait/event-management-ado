import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/DataTableController.getContactList';

const actions = [
    { label: 'Show details', Name: 'details' },
    { label: 'Delete', Name: 'Delete' }
];
const columns = [
    {
        label: 'Name', fieldName: 'recordUrl', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            },
            target: '_blank'
        },
        cellAttributes: {
            iconName: {
                fieldName: 'contactIcon'
            },
            iconPosition: 'left',
            iconAlternativeText: 'Contact Icon'
        }
    },
    { label: 'Phone', fieldName: 'Phone', type: 'Phone' },
    { label: 'Title', fieldName: 'Title', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'Email' },
    { label: 'AccountId', fieldName: 'AccountId', type: 'text' },
    {
        label: 'Account Name', fieldName: 'accountUrl', type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'ACCOUNT_NAME'
            },
            target: '_blank'
        },
        cellAttributes: {
            iconName: 'standard:account',
            iconPosition: 'right',
            iconAlternativeText: 'accountIcon'
        }
    },
    {
        type: "button",
        fixedWidth: 150,
        typeAttributes: {
            label: 'View Details',
            tittle: 'View Details',
            name: 'view Details',
            value: 'view Details',
            variant: 'brand'
        }
    },
    { type: 'action', typeAttributes: { rowActions: actions } },
];

export default class DatatableComponent extends LightningElement {
    /** Simple Comment */
    /** Simple Comment */
    contactData;
    coulumList = columns;
    error;
    @wire(getContactList)
    wireddata({ error, data }) {
        if (data) {
            console.log('Data \n ', data);
            let parsedData = JSON.parse(JSON.stringify(data));
            let baseUrl = 'https://' + location.host + '/';
            parsedData.forEach(contact => {
                if (contact.AccountId) {
                    contact.ACCOUNT_NAME = contact.Account.Name;
                    contact.recordUrl = baseUrl + contact.Id;
                    contact.accountUrl = baseUrl + contact.AccountId;
                    contact.accountIcon = 'standard:account';
                    contact.contactIcon = 'standard:contact';
                }
            });
            console.log('Modified Data \n ', parsedData);
            this.contactData = parsedData;
            this.error = undefined;
        } else if (error) {
            console.error('Error: \n', error);
            this.contactData = undefined;
            this.error = error;
        }
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        alert(action.name);
        switch (action.name) {
            case 'details':
                this.handleDelete(row.Id);
                break;
            case 'delete':
                alert('deleting:' + JSON.stringify(row));
                break;
            case 'View Details':
                alert('View Details:' + row.Id);
                break;
        }
    }
    handleDelete(recordId) {
        alert('Deleting Record ' + recordId);
    }
}