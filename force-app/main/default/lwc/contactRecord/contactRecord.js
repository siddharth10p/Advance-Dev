import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

import updateContact from '@salesforce/apex/ContactListController.updateContact';
import FIRSTNAME from '@salesforce/schema/Contact.FirstName';
import LASTNAME from '@salesforce/schema/Contact.LastName';
import EMAIL from '@salesforce/schema/Contact.Email';
import PHONE from '@salesforce/schema/Contact.Phone';
import ID from '@salesforce/schema/Contact.Id';

export default class ContactRecord extends LightningElement {
    @api contact;
    @track editMode = false;
    recordInput;
    contactRec;

    handleEdit() {
        this.editMode = true;
    }

    handleSave() {
        this.updateRecord(this.recordInput);
        this.editMode = false;
    }

    handleChange(event) {
        const title = event.target.title;
        const fields = {};
        if (title === 'FirstName') {
            fields[FIRSTNAME.fieldApiName] = event.target.value;
        }
        if (title === 'LastName') {
            fields[LASTNAME.fieldApiName] = event.target.value;
        }
        if (title === 'Email') {
            fields[EMAIL.fieldApiName] = event.target.value;
        }
        if (title === 'Phone') {
            fields[PHONE.fieldApiName] = event.target.value;
        }
        fields[ID.fieldApiName] = this.contact.Id;
        this.recordInput = { fields };
    }

    updateRecord(record) {
        updateRecord(record)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact updated',
                        variant: 'success'
                    })
                );
                console.log('record is updated');
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
                console.log('Error ==> ', error);
            });
    } 
}