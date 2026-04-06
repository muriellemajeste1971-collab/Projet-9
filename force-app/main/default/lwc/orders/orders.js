import { LightningElement, api } from 'lwc';
import getAccountCA from '@salesforce/apex/OrderController.getAccountCA';

export default class Orders extends LightningElement {

    sumOrdersOfCurrentAccount;
    showError = false;
    showSuccess = false;

    @api recordId;

    

    connectedCallback() {
        this.fetchSumOrders();
    }

    fetchSumOrders() {
        getAccountCA({ accountId: this.recordId })
            .then(result => {
                this.sumOrdersOfCurrentAccount = result.Chiffre_d_affaire__c;

                if (!this.sumOrdersOfCurrentAccount || this.sumOrdersOfCurrentAccount <= 0) {
                    this.showError = true;
                    this.showSuccess = false;
                } else {
                    this.showError = false;
                    this.showSuccess = true;
                }
            })
            .catch(error => {
                console.error(error);
                this.showError = true;
                this.showSuccess = false;
            });
    }
}
