import { LightningElement } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import FULLCALENDAR from '@salesforce/resourceUrl/fullcalendar4';

export default class Calendar extends LightningElement {
    events = [
        { title: 'Event One', start: '2019-07-05', end: '2019-07-05' },
        { title: 'Event Two', start: '2019-07-06', end: '2019-07-06' }
    ];

    fullCalendarJsInitialised = false;

    renderedCallback() {
        if (this.fullCalendarJsInitialised) {
            return;
        }
        this.fullCalendarJsInitialised = true;

        Promise.all([
            loadStyle(this, FULLCALENDAR + '/fullcalendar-4.2.0/packages/core/main.min.css'),
            loadScript(this, FULLCALENDAR + '/fullcalendar-4.2.0/packages/core/main.min.js')
        ])
            .then(() => {
                Promise.all([
                    loadStyle(this, FULLCALENDAR + '/fullcalendar-4.2.0/packages/daygrid/main.min.css'),
                    loadScript(this, FULLCALENDAR + '/fullcalendar-4.2.0/packages/daygrid/main.min.js')
                ])
                    .then(() => {
                        this.initializeCalendar();
                    })
                    .catch(error => {
                        throw error;
                    });
            })
            .catch(error => {
                console.error({
                    message: 'Error occurred on Fullcalendar load.',
                    error
                });
            })
    }

    initializeCalendar() {
        let calendar = new FullCalendar.Calendar(this.template.querySelector('div.fullcalendarjs'), {
            plugins: ['dayGrid'],
            defaultView: 'dayGridWeek',
            event: this.events
        });

        calendar.render();
    }
}