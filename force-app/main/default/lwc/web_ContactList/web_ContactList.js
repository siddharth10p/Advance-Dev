import { LightningElement, api } from 'lwc';
import fetchContacts from '@salesforce/apex/ContactListController.getContactList';

export default class Web_ContactList extends LightningElement {
    @api recordId;

    contactList;
    error;

    connectedCallback(){
        this.fetchContactList();
    }

    // a method to fetch the contactlist
    fetchContactList() {
		fetchContacts({ accountIds : this.recordId })
		.then(result => {
			this.contactList = result;
			this.error = undefined;

		}) .catch(error => {
			this.error = error;
			this.contactList = undefined;
		});
	}

}