import LightningDatatable from 'lightning/datatable';
import customPicture from './templates/customPicture.html';
import picklistTemplate from './templates/picklist.html';
import customPicklistEditTemplate from "./templates/picklistEdit.html";
import toggelTemplate from './templates/toggelTemplate.html';
import customNumberTemplate from "./templates/customNumber.html";
import customNumberEditTemplate from "./templates/customNumberEdit.html";
export default class Tf_CustomDataTable extends LightningDatatable {
    static customTypes = {
        customPictureType: {
            template: customPicture,
            standardCellLayout: true,
            typeAttributes: ['pictureUrl', 'context']
        },
        picklist: {
            template: picklistTemplate,
            editTemplate: customPicklistEditTemplate,
            standardCellLayout: true,
            typeAttributes: [
                'name', 'label', 'value', 'placeholder', 'context', 'options', 'variant'
            ]
        },
        toggel: {
            template:  toggelTemplate,
            standardCellLayout: true,
            typeAttributes : ['value', 'context']
        },
        customNumber: {
            template: customNumberTemplate,
            editTemplate: customNumberEditTemplate,
            standardCellLayout: true,
            typeAttributes: ["status", "min", "currencyCode", "percent", "required"],
        },
    };
}