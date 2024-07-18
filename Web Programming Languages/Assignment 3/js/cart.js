import { cardRow } from './utils.js';

const passengerRow = (label_text, type, i) => {
    const label_id = `passenger[${i}][${label_text.toLowerCase().replace(/[\s:]+/g, '')}]`;
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

const loadFlightData = (flights) => {
    let flightData = [];
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/flights.xml', false);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            flightData = $(this.responseXML).find('flight').toArray().map(
                flight => ({
                    origin: $(flight).find('origin').text(),
                    destination: $(flight).find('destination').text(),
                    departureDate: $(flight).find('departure-date').text(),
                    arrivalDate: $(flight).find('arrival-date').text(),
                    departureTime: $(flight).find('departure-time').text(),
                    arrivalTime: $(flight).find('arrival-time').text(),
                    availableSeats: parseInt($(flight).find('available-seats').text()),
                    price: parseFloat($(flight).find('price').text()),
                    flightId: $(flight).find('flight-id').text(),
                })
            );
        }
    }
    xhttp.send();

    return flights.map(flight => {
        return {
            ...flight,
            ...flightData.find(f => f.flightId === flight.flightId)
        };
    });
}

const loadSavedFlights = () => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/saved-flights.xml', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const flights = $(this.responseXML).find('flight').toArray().map(
                flight => ({
                    'flightId': $(flight).find('flight-id').text(),
                    'adults': parseInt($(flight).find('adults').text()),
                    'children': parseInt($(flight).find('children').text()),
                    'infants': parseInt($(flight).find('infants').text()),
                    'savingNumber': $(flight).find('saving-number').text()
                })
            );

            const flightData = loadFlightData(flights);

            for (const flight of flightData) {
                const bookButton = $('<button></button>')
                    .addClass('col')
                    .text('Book')
                    .attr('type', 'submit')
                    .on('click', function (e) {
                        e.preventDefault();
                        const passengerForm = $('#passenger-form');
                        passengerForm.empty();
                        passengerForm.append(
                            $('<h2></h2>').text('Passenger Information')
                        );

                        for (let i = 1; i <= flight.adults + flight.children + flight.infants; i++) {
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

                        $(passengerForm).off('submit').on('submit', function (e) {
                            e.preventDefault();

                            $.ajax({
                                type: 'POST',
                                url: 'php/save_or_book_flight.php',
                                data: {
                                    flightId: flight.flightId,
                                    adults: flight.adults,
                                    children: flight.children,
                                    infants: flight.infants,
                                    savingNumber: flight.savingNumber,
                                    passengers: Object.fromEntries(new FormData(this)),
                                    action: 'book'
                                },
                                success: function () {
                                    alert('Booked flight successfully!');
                                    location.reload();
                                }
                            });
                        });
                    });

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
        }
    }
    xhttp.send();
}

const loadBookedFlights = () => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/booked-flights.xml', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const flights = $(this.responseXML).find('flight').toArray().map(
                flight => ({
                    'bookingNumber': $(flight).find('booking-number').text(),
                    'flightId': $(flight).find('flight-id').text(),
                    'adults': parseInt($(flight).find('adults').text()),
                    'children': parseInt($(flight).find('children').text()),
                    'infants': parseInt($(flight).find('infants').text()),
                    'passengers': $(flight).find('passenger'),
                })
            );

            const flightData = loadFlightData(flights);

            for (const flight of flightData) {
                const passengerInfoButton = $('<button></button>')
                    .attr('type', 'submit')
                    .addClass('col passengers-button')
                    .text('Passengers')
                    .on('click', function (e) {
                        e.preventDefault();

                        const passengerInfo = $('<div></div>');
                        flight.passengers.each((i, passenger) => {
                            const firstName = $(passenger).find('firstname').text();
                            const lastName = $(passenger).find('lastname').text();
                            const dob = $(passenger).find('dateofbirth').text();
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
                        cardRow('Total Price', `$${flight.price * (flight.adults + (flight.children * .7) + (flight.infants * .1))}`),
                        $('<div></div>').addClass('row').append(passengerInfoButton)
                    )
                );
            }
        }
    }
    xhttp.send();
}

$(document).ready(function () {
    loadSavedFlights();
    loadBookedFlights();
});