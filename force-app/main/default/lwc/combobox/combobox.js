import { LightningElement, api } from 'lwc';

export default class Combobox extends LightningElement {
    @api name;
    @api label;
    @api value;
    @api placeholder;
    @api options;
    @api index;
    @api variant;

    connectedCallback(){
        console.log(this.name)
        console.log(this.label)
        console.log(this.value)
        console.log(this.placeholder)
        console.log(this.options)
        console.log(this.variant)
    }

    /* handleChange(event) {
        event.preventDefault();
        let value = event.target.value;
        const picklist = new CustomEvent('picklistselect', {
            detail: {
                value: value,
                index: this.index
            },
            bubbles: true,
            composed: true,
            cancelable: true
        });
        this.dispatchEvent(picklist);
    } */

}