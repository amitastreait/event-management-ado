import { LightningElement, api, track } from 'lwc';

import searchRecords from '@salesforce/apex/CustomSearchController.searchRecords';



export default class Customlwclookup extends LightningElement {



    @api objectName = 'Account';

    @api fieldName = 'Name';

    @api iconname = 'standard:record';

    @api label = 'Account';

    @api parentidfield = 'AccountId';



    /* private property */

    @track records;

    @track selectedRecord;



    hanldeSearch(event) {



        var searchVal = event.detail.value;
        console.log('searchVal', searchVal);
        searchRecords({

            objName: this.objectName,

            fieldName: this.fieldName,

            searchKey: searchVal

        })

            .then(data => {
                console.log('data', data);
                if (data) {

                    let parsedResponse = JSON.parse(data);

                    let searchRecordList = parsedResponse[0];

                    for (let i = 0; i < searchRecordList.length; i++) {

                        let record = searchRecordList[i];

                        record.Name = record[this.fieldName];



                    }

                    this.records = searchRecordList;

                }

            })

            .catch(error => {

                window.console.log(' error ', error);

            });

    }



    handleSelect(event) {

        var selectedVal = event.detail.selRec;

        this.selectedRecord = selectedVal;

        let finalRecEvent = new CustomEvent('select', {

            detail: { selectedRecordId: this.selectedRecord.Id, parentfield: this.parentidfield }

        });

        this.dispatchEvent(finalRecEvent);

    }



    handleRemove() {

        this.selectedRecord = undefined;

        this.records = undefined;

        let finalRecEvent = new CustomEvent('select', {

            detail: { selectedRecordId: undefined, parentfield: this.parentidfield }

        });

        this.dispatchEvent(finalRecEvent);

    }



} 