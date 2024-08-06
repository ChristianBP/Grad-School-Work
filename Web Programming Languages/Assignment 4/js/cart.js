import { cardRow } from './utils.js';

const emptyForms = () => {
    $('#passenger-form').empty();
    $('#guest-form').empty();
};

const formRow = (label_text, type, i) => {
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

const flightCard = ({
    origin,
    destination,
    flight_id,
    departure_time,
    departure_date,
    arrival_time,
    arrival_date,
    total_price
}) => ([
    $('<h2></h2>').text(`${origin} to ${destination}`),
    cardRow('Flight ID', flight_id),
    cardRow('Departure', `${departure_time} ${departure_date}`),
    cardRow('Arrival', `${arrival_time} ${arrival_date}`),
    cardRow('Total Price', `$${total_price}`),
]);

const hotelCard = ({
    hotel_name,
    hotel_id,
    city,
    check_in_date,
    check_out_date,
    number_of_rooms,
    price_per_night,
    total_price
}) => ([
    $('<h2></h2>').text(`${hotel_name}`),
    cardRow('Hotel ID', hotel_id),
    cardRow('City', city),
    cardRow('Check In Date', check_in_date),
    cardRow('Check Out Date', check_out_date),
    cardRow('Price Per Night', `$${price_per_night}`),
    cardRow('Total Price', `$${total_price}`),
    cardRow('Number of Rooms', number_of_rooms),
]);


const loadSavedFlights = () => {
    $.get('xml_data/saved-flights.xml', function (xml) {
        const flights = $(xml).find('flight').toArray().map(
            flight => {
                const departureFlightId = $(flight).find('departure-flight-id');
                const returnFlightId = $(flight).find('return-flight-id');
                let res = {
                    'departure': {
                        'flight_id': departureFlightId.text()
                    },
                    'adults': parseInt($(flight).find('adults').text()),
                    'children': parseInt($(flight).find('children').text()),
                    'infants': parseInt($(flight).find('infants').text()),
                    'savingNumber': $(flight).find('saving-number').text(),
                };
                if (returnFlightId.length > 0) {
                    res['returning'] = {
                        'flight_id': returnFlightId.text(),
                    };
                }
                return res;
            }
        );

        $.get('php/cart/get_flights.php', function (data) {
            let flightData = JSON.parse(data);
            flightData = flights.map(flight => {
                let res = {
                    ...flight,
                    'departure': {
                        ...flight.departure,
                        ...flightData.find(f => f.flight_id === flight.departure.flight_id)
                    }
                };
                if (flight.returning) {
                    res['returning'] = {
                        ...flight.returning,
                        ...flightData.find(f => f.flight_id === flight.returning.flight_id)
                    };
                }
                return res;
            });

            for (const flight of flightData) {
                flight.departure.total_price = flight.departure.price * (flight.adults + (flight.children * .7) + (flight.infants * .1));
                if (flight.returning) {
                    flight.returning.total_price = flight.returning.price * (flight.adults + (flight.children * .7) + (flight.infants * .1));
                }
            }

            for (const {departure, returning, adults, children, infants, savingNumber} of flightData) {
                const bookButton = $('<button></button>')
                    .addClass('col')
                    .text('Book')
                    .attr('type', 'submit')
                    .on('click', function (e) {
                        e.preventDefault();

                        emptyForms();
                        const passengerForm = $('#passenger-form');
                        passengerForm.append(
                            $('<h2></h2>').text('Passenger Information')
                        );

                        for (let i = 1; i <= adults + children + infants; i++) {
                            const category = i <= adults ? 'Adult' : i <= adults + children ? 'Child' : 'Infant';
                            $(passengerForm).append(
                                $('<h3></h3>').text(`${category}`),
                                formRow('First Name:', 'text', i),
                                formRow('Last Name:', 'text', i),
                                formRow('Date of Birth:', 'date', i),
                                formRow('SSN:', 'text', i),
                                $('<input>').attr({
                                    type: 'hidden',
                                    id: `passenger[${i}][category]`,
                                    name: `passenger[${i}][category]`,
                                    value: category
                                })
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

                            $.post('php/save_or_book_flight.php',
                                {
                                    departureFlightId: departure.flight_id,
                                    returnFlightId: returning ? returning.flight_id : null,
                                    adults: adults,
                                    children: children,
                                    infants: infants,
                                    savingNumber: savingNumber,
                                    passengers: Object.fromEntries(new FormData(this)),
                                    action: 'book'
                                },
                                function () {
                                    alert('Booked flight successfully!');
                                    location.reload();
                                }
                            );
                        });
                    });

                $('#saved-flights').append(
                    $('<form></form>').addClass('card flight-card col').append(
                        flightCard(departure),
                        returning ? flightCard(returning) : [],
                        $('<div></div>').addClass('row').append(bookButton)
                    )
                );
            }
        });
    });
}

const loadBookedFlights = () => {
    $.get('php/cart/get_booked_flights.php', function (flightData) {
        for (const {departure, passengers, returning} of JSON.parse(flightData)) {
            const passengerInfoButton = $('<button></button>')
                .attr('type', 'submit')
                .addClass('col')
                .text('Passengers')
                .on('click', function (e) {
                    e.preventDefault();

                    const passengerInfo = $('<div></div>');
                    for (const {first_name, last_name, date_of_birth, SSN, category, tickets} of passengers) {
                        passengerInfo.append(
                            $('<p></p>').text(`Name: ${first_name} ${last_name}`),
                            $('<p></p>').text(`Date of Birth: ${date_of_birth}`),
                            $('<p></p>').text(`SSN: ${SSN}`),
                            $('<p></p>').text(`Category: ${category}`)
                        );

                        for (const ticket of tickets) {
                            passengerInfo.append(
                                $('<p></p>').html(`Ticket Price: $${ticket.price}<br>Ticket ID: ${ticket.ticket_id}`)
                            );
                        }

                        passengerInfo.append($('<hr>'));
                    };

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
                    flightCard(departure),
                    returning ? flightCard(returning) : [],
                    cardRow('Booking ID', departure.flight_booking_id),
                    $('<div></div>').addClass('row').append(passengerInfoButton),
                )
            );
        }
    });
}

const loadSavedHotels = () => {
    $.get('json_data/saved-hotels.json', function (savedHotels) {
        $.get('json_data/hotels.json', function (hotelData) {
            const hotels = savedHotels.map(hotel => {
                return {
                    ...hotel,
                    ...hotelData.find(h => h.hotel_id === hotel.hotel_id)
                };
            });

            for (const hotel of hotels) {
                const {hotel_id, price_per_night, number_of_rooms, check_in_date, check_out_date, adults, children, infants, saving_number} = hotel;
                hotel.total_price = price_per_night * number_of_rooms * (new Date(check_out_date) - new Date(check_in_date)) / (1000 * 60 * 60 * 24);

                const bookButton = $('<button></button>')
                    .addClass('col')
                    .text('Book')
                    .attr('type', 'submit')
                    .on('click', function (e) {
                        e.preventDefault();

                        emptyForms();
                        const guestForm = $('#guest-form');
                        guestForm.append(
                            $('<h2></h2>').text('Guest Information')
                        );

                        for (let i = 1; i <= adults + children + infants; i++) {
                            const category = i <= adults ? 'Adult' : i <= adults + children ? 'Child' : 'Infant';
                            $(guestForm).append(
                                $('<h3></h3>').text(`${category}`),
                                formRow('First Name:', 'text', i),
                                formRow('Last Name:', 'text', i),
                                formRow('Date of Birth:', 'date', i),
                                formRow('SSN:', 'text', i),
                                $('<input>').attr({
                                    type: 'hidden',
                                    id: `passenger[${i}][category]`,
                                    name: `passenger[${i}][category]`,
                                    value: category
                                })
                            );
                        }

                        guestForm.append(
                            $('<button></button>')
                                .text('Checkout')
                                .addClass('mt-1')
                                .attr('type', 'submit')
                        );

                        $(guestForm).off('submit').on('submit', function (e) {
                            e.preventDefault();

                            $.post('php/save_or_book_hotel.php',
                                {
                                    hotel_id: hotel_id,
                                    check_in_date: check_in_date,
                                    check_out_date: check_out_date,
                                    adults: adults,
                                    children: children,
                                    infants: infants,
                                    number_of_rooms: number_of_rooms,
                                    price_per_night: price_per_night,
                                    total_price: hotel.total_price,
                                    saving_number: saving_number,
                                    guests: Object.fromEntries(new FormData(this)),
                                    action: 'book'
                                },
                                function () {
                                    alert('Booked hotel successfully!');
                                    location.reload();
                                }
                            );
                        });
                    });

                $('#saved-hotels').append(
                    $('<form></form>').addClass('card hotel-card col').append(
                        hotelCard(hotel),
                        cardRow('Adults', adults),
                        cardRow('Children', children),
                        cardRow('Infants', infants),
                        $('<div></div>').addClass('row').append(bookButton)
                    )
                );
            }
        });
    });
}

const loadBookedHotels = () => {
    $.get('php/cart/get_booked_hotels.php', function (hotels) {
        for (const hotel of JSON.parse(hotels)) {
            const guestInfoButton = $('<button></button>')
                .attr('type', 'submit')
                .addClass('col')
                .text('Guests')
                .on('click', function (e) {
                    e.preventDefault();

                    const guestInfo = $('<div></div>');
                    for (const {first_name, last_name, date_of_birth, ssn, category} of hotel.guests) {
                        guestInfo.append(
                            $('<p></p>').text(`Name: ${first_name} ${last_name}`),
                            $('<p></p>').text(`Date of Birth: ${date_of_birth}`),
                            $('<p></p>').text(`SSN: ${ssn}`),
                            $('<p></p>').text(`Category: ${category}`)
                        );

                        guestInfo.append($('<hr>'));
                    };

                    $(guestInfo).dialog({
                        title: 'Guest Information',
                        modal: true,
                        buttons: {
                            Ok: function () {
                                $(this).dialog('close');
                            }
                        }
                    });
                });
            $('#booked-hotels').append(
                $('<div></div>').addClass('card hotel-card col').append(
                    hotelCard(hotel),
                    cardRow('Booking ID', hotel.hotel_booking_id),
                    $('<div></div>').addClass('row').append(guestInfoButton),
                )
            );
        }
    });
}

$(document).ready(function () {
    loadSavedFlights();
    loadBookedFlights();
    loadSavedHotels();
    loadBookedHotels();
});