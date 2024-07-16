import { cardRow } from './utils.js';

const passengerRow = (label_text, type, i) => {
    const label_id = `passenger${i}-${label_text.toLowerCase().replace(/\s+/g, '-')}`;
    return [
        $('<label></label>')
            .text(label_text)
            .attr('for', label_id),
        $('<input>').attr({
            type: type,
            id: label_id,
            name: label_id,
            required: ''
        })
    ];
};


$(document).ready(function () {
    let xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/saved-flights.xml', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const flightData = $(this.responseXML).find('flight').toArray().map(
                flight => ({
                    'origin': $(flight).find('origin').text(),
                    'destination': $(flight).find('destination').text(),
                    'departureDate': $(flight).find('departure-date').text(),
                    'arrivalDate': $(flight).find('arrival-date').text(),
                    'departureTime': $(flight).find('departure-time').text(),
                    'arrivalTime': $(flight).find('arrival-time').text(),
                    'price': parseFloat($(flight).find('price').text()),
                    'flightId': $(flight).find('flight-id').text(),
                    'adults': parseInt($(flight).find('adults').text()),
                    'children': parseInt($(flight).find('children').text()),
                    'infants': parseInt($(flight).find('infants').text()),
                })
            );

            for (const flight of flightData) {
                const bookButton = $('<button></button>')
                    .addClass('col')
                    .text('Book')
                    .attr('type', 'submit');

                $('#saved-flights').append(
                    $('<form></form>').addClass('card flight-card col-25').append(
                        $('<h2></h2>').text(`${flight.origin} to ${flight.destination}`),
                        cardRow('Flight ID', flight.flightId),
                        cardRow('Departure', `${flight.departureTime} ${flight.departureDate}`),
                        cardRow('Arrival', `${flight.arrivalTime} ${flight.arrivalDate}`),
                        cardRow('Adults', flight.adults),
                        cardRow('Children', flight.children),
                        cardRow('Infants', flight.infants),
                        cardRow('Total Price', `$${flight.price * (flight.adults + (flight.children * .7) + (flight.infants * .1))}`),
                        $('<div></div>').addClass('row').append(bookButton)
                    )
                );
            }

            $('.flight-card').on('submit', function (e) {
                e.preventDefault();

                const flightId = $(this).find('input[name="Flight ID"]').val();
                const adults = parseInt($(this).find('input[name="Adults"]').val());
                const children = parseInt($(this).find('input[name="Children"]').val());
                const infants = parseInt($(this).find('input[name="Infants"]').val());

                const passengerForm = $('#passenger-form');
                passengerForm.empty();
                passengerForm.append(
                    $('<input>').attr({
                        type: 'hidden',
                        name: 'flightId',
                        value: flightId
                    }),
                    $('<h2></h2>').text('Passenger Information')
                );

                for (let i = 1; i <= adults + children + infants; i++) {
                    $(passengerForm).append(
                        $('<h3></h3>').text(`Passenger ${i}`),
                        passengerRow('First Name:', 'text', i),
                        passengerRow('Last Name:', 'text', i),
                        passengerRow('Date of Birth:', 'date', i),
                        passengerRow('SSN:', 'text', i)
                    );
                }

                passengerForm.append(
                    $('<button></button>')
                        .text('Checkout')
                        .addClass('mt-1')
                        .attr('type', 'submit')
                );

                $('#passenger-form').on('submit', function (e) {
                    e.preventDefault();
                    const bookingNumber = Math.floor(Math.random() * 1000000);

                });
            });
        }
    }
    xhttp.send();

    xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/booked-flights.xml', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const flights = $(this.responseXML).find('flight').map(flight => $(flight));

            const flightData = flights.map(flight => ({
                'bookingNumber': flight.find('booking-number').text(),
                'flightId': flight.find('flight-id').text(),
                'origin': flight.find('origin').text(),
                'destination': flight.find('destination').text(),
                'departureDate': flight.find('departure-date').text(),
                'arrivalDate': flight.find('arrival-date').text(),
                'departureTime': flight.find('departure-time').text(),
                'arrivalTime': flight.find('arrival-time').text(),
                'price': parseFloat(flight.find('price').text()),
                'passengers': flight.find('passengers'),
            }));

            for (const flight of flightData) {
                const passengerInfoButton = $('<button></button>')
                    .attr('type', 'submit')
                    .addClass('col passengers-button')
                    .text('Passengers')
                    .on('click', function (e) {
                        e.preventDefault();

                        const passengerInfo = $('<div></div>');
                        flight.passengers.children.forEach(passenger => {
                            const firstName = $(passenger).find('first-name').text();
                            const lastName = $(passenger).find('last-name').text();
                            const dob = $(passenger).find('dob').text();
                            const ssn = $(passenger).find('ssn').text();

                            passengerInfo.append(
                                $('<p></p>').text(`Name: ${firstName} ${lastName}`),
                                $('<p></p>').text(`Date of Birth: ${dob}`),
                                $('<p></p>').text(`SSN: ${ssn}`),
                                $('<hr>')
                            );
                        });

                        $(passengerInfo).dialog({
                            title: 'Passenger Information',
                            modal: true,
                            buttons: {
                                Ok: function () {
                                    $(this).dialog('close');
                                }
                            }
                        });
                    });

                $('#booked-flights').append(
                    $('<form></form>').addClass('card flight-card col-25').append(
                        $('<h2></h2>').text(`${flight.origin} to ${flight.destination}`),
                        cardRow('Booking Number', flight.bookingNumber),
                        cardRow('Flight ID', flight.flightId),
                        cardRow('Departure', `${flight.departureTime} ${flight.departureDate}`),
                        cardRow('Arrival', `${flight.arrivalTime} ${flight.arrivalDate}`),
                        cardRow('Total Price', `$${flight.price}`),
                        $('<div></div>').addClass('row').append(passengerInfoButton)
                    )
                );
            }
        }
    }
    xhttp.send();
});