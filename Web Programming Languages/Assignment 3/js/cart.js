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
        let res = {
            ...flight,
            'departure': {
                ...flight.departure,
                ...flightData.find(f => f.flightId === flight.departure.flightId)
            }
        };
        if (flight.returning) {
            res['returning'] = {
                ...flight.returning,
                ...flightData.find(f => f.flightId === flight.returning.flightId)
            };
        }
        return res;
    });
}

const loadSavedFlights = () => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/saved-flights.xml', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const flights = $(this.responseXML).find('flight').toArray().map(
                flight => {
                    const departureFlightId = $(flight).find('departure-flight-id');
                    const returnFlightId = $(flight).find('return-flight-id');
                    let res = {
                        'departure': {
                            'flightId': departureFlightId.text()
                        },
                        'adults': parseInt($(flight).find('adults').text()),
                        'children': parseInt($(flight).find('children').text()),
                        'infants': parseInt($(flight).find('infants').text()),
                        'savingNumber': $(flight).find('saving-number').text(),
                    };
                    if (returnFlightId.length > 0) {
                        res['returning'] = {
                            'flightId': returnFlightId.text(),
                        };
                    }
                    return res;
                }
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
                                    departureFlightId: flight.departure.flightId,
                                    returnFlightId: flight.returning ? flight.returning.flightId : null,
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
                    $('<form></form>').addClass('card flight-card col').append(
                        $('<h2></h2>').text(`${flight.departure.origin} to ${flight.departure.destination}`),
                        cardRow('Flight ID', flight.departure.flightId),
                        cardRow('Departure', `${flight.departure.departureTime} ${flight.departure.departureDate}`),
                        cardRow('Arrival', `${flight.departure.arrivalTime} ${flight.departure.arrivalDate}`),
                        cardRow('Adults', flight.adults),
                        cardRow('Children', flight.children),
                        cardRow('Infants', flight.infants),
                        cardRow('Total Price', `$${flight.departure.price * (flight.adults + (flight.children * .7) + (flight.infants * .1))}`),
                        flight.returning ? [
                            $('<h2></h2>').text(`${flight.returning.origin} to ${flight.returning.destination}`),
                            cardRow('Flight ID', flight.returning.flightId),
                            cardRow('Departure', `${flight.returning.departureTime} ${flight.returning.departureDate}`),
                            cardRow('Arrival', `${flight.returning.arrivalTime} ${flight.returning.arrivalDate}`),
                            cardRow('Adults', flight.adults),
                            cardRow('Children', flight.children),
                            cardRow('Infants', flight.infants),
                            cardRow('Total Price', `$${flight.returning.price * (flight.adults + (flight.children * .7) + (flight.infants * .1))}`)
                        ] : [],
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
                flight => {
                    const departureFlightId = $(flight).find('departure-flight-id');
                    const returnFlightId = $(flight).find('return-flight-id');
                    let res = {
                        'departure': {
                            'flightId': departureFlightId.text()
                        },
                        'adults': parseInt($(flight).find('adults').text()),
                        'children': parseInt($(flight).find('children').text()),
                        'infants': parseInt($(flight).find('infants').text()),
                        'passengers': $(flight).find('passenger'),
                        'bookingNumber': $(flight).find('booking-number').text(),
                        'returnBookingNumber': $(flight).find('return-booking-number').text()
                    };
                    if (returnFlightId.length > 0) {
                        res['returning'] = {
                            'flightId': returnFlightId.text(),
                        };
                    }
                    return res;
                }
            );
            console.log(flights);

            const flightData = loadFlightData(flights);
            console.log(flightData);

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
                    $('<form></form>').addClass('card flight-card col').append(
                        $('<h2></h2>').text(`${flight.departure.origin} to ${flight.departure.destination}`),
                        cardRow('Flight ID', flight.departure.flightId),
                        cardRow('Departure', `${flight.departure.departureTime} ${flight.departure.departureDate}`),
                        cardRow('Arrival', `${flight.departure.arrivalTime} ${flight.departure.arrivalDate}`),
                        cardRow('Total Price', `$${flight.departure.price * (flight.adults + (flight.children * .7) + (flight.infants * .1))}`),
                        cardRow('Booking Number', flight.bookingNumber),
                        flight.returning ? [
                            $('<h2></h2>').text(`${flight.returning.origin} to ${flight.returning.destination}`),
                            cardRow('Flight ID', flight.returning.flightId),
                            cardRow('Departure', `${flight.returning.departureTime} ${flight.returning.departureDate}`),
                            cardRow('Arrival', `${flight.returning.arrivalTime} ${flight.returning.arrivalDate}`),
                            cardRow('Total Price', `$${flight.returning.price * (flight.adults + (flight.children * .7) + (flight.infants * .1))}`),
                            cardRow('Return Booking Number', flight.returnBookingNumber),
                        ] : [],
                        $('<div></div>').addClass('row').append(passengerInfoButton),
                    )
                );
            }
        }
    }
    xhttp.send();
}

const loadHotelData = (hotels) => {
    let hotelData = [];
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'json_data/hotels.json', false);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            hotelData = JSON.parse(this.responseText);
        }
    }
    xhttp.send();

    return hotels.map(hotel => {
        return {
            ...hotel,
            ...hotelData.find(h => h.hotel_id === hotel.hotel_id)
        };
    });
}

const loadSavedHotels = () => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'json_data/saved-hotels.json', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const hotels = loadHotelData(JSON.parse(this.responseText));

            for (const hotel of hotels) {
                const total_price = hotel.price_per_night * (new Date(hotel.check_out_date) - new Date(hotel.check_in_date)) / (1000 * 60 * 60 * 24);

                const bookButton = $('<button></button>')
                    .addClass('col')
                    .text('Book')
                    .attr('type', 'submit')
                    .on('click', function (e) {
                        e.preventDefault();

                        $.ajax({
                            type: 'POST',
                            url: 'php/save_or_book_hotel.php',
                            data: {
                                hotel_id: hotel.hotel_id,
                                city: hotel.city,
                                hotel_name: hotel.hotel_name,
                                check_in_date: hotel.check_in_date,
                                check_out_date: hotel.check_out_date,
                                adults: hotel.adults,
                                children: hotel.children,
                                infants: hotel.infants,
                                num_rooms: hotel.num_rooms,
                                price_per_night: hotel.price_per_night,
                                total_price: total_price,
                                saving_number: hotel.saving_number,
                                action: 'book'
                            },
                            success: function () {
                                alert('Booked hotel successfully!');
                                location.reload();
                            }
                        });
                    });

                $('#saved-hotels').append(
                    $('<form></form>').addClass('card hotel-card col').append(
                        $('<h2></h2>').text(`${hotel.hotel_name}`),
                        cardRow('Hotel ID', hotel.hotel_id),
                        cardRow('City', `${hotel.city}`),
                        cardRow('Adults', hotel.adults),
                        cardRow('Children', hotel.children),
                        cardRow('Infants', hotel.infants),
                        cardRow('Check In Date', hotel.check_in_date),
                        cardRow('Check Out Date', hotel.check_out_date),
                        cardRow('Number of Rooms', hotel.num_rooms),
                        cardRow('Price Per Night', `$${hotel.price_per_night}`),
                        cardRow('Total Price', `$${total_price}`),
                        $('<div></div>').addClass('row').append(bookButton)
                    )
                );
            }
        }
    }
    xhttp.send();
}

const loadBookedHotels = () => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'json_data/booked-hotels.json', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const hotels = JSON.parse(this.responseText);

            for (const hotel of hotels) {
                $('#booked-hotels').append(
                    $('<div></div>').addClass('card hotel-card col').append(
                        $('<h2></h2>').text(`${hotel.hotel_name}`),
                        cardRow('Hotel ID', hotel.hotel_id),
                        cardRow('City', `${hotel.city}`),
                        cardRow('Adults', hotel.adults),
                        cardRow('Children', hotel.children),
                        cardRow('Infants', hotel.infants),
                        cardRow('Check In Date', hotel.check_in_date),
                        cardRow('Check Out Date', hotel.check_out_date),
                        cardRow('Number of Rooms', hotel.num_rooms),
                        cardRow('Price Per Night', `$${hotel.price_per_night}`),
                        cardRow('Total Price', `$${hotel.total_price}`),
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
    loadSavedHotels();
    loadBookedHotels();
});