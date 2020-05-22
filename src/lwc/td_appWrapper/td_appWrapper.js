import { LightningElement, wire } from "lwc";
import getTasks from '@salesforce/apex/TodoController.getTasks';

export default class TdAppWrapper extends LightningElement {
    @wire(getTasks) tasks;
}