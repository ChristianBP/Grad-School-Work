import { validCities } from './locations.js';
import { cardRow } from './utils.js';

const showAvailableFlights = (origin, destination, departureDate, adults, children, infants, departureDateReturn, firstFlightId = null) => {
    $.get('php/get_available_flights.php', {
        origin: origin,
        destination: destination,
        departureDate: departureDate.toISOString().split('T')[0],
        adults: adults,
        children: children,
        infants: infants
    }, function (data) {
        const flightData = JSON.parse(data);

        if (flightData.length == 0) {
            $('#available-flights').text('No flights available.');
            return;
        }

        $('#available-flights').empty();
        $('#available-flights').append($('<h2></h2>').text(firstFlightId ? "Return" : "Departure"));
        for (const flight of flightData) {
            const addToCartButton = $('<button></button>')
                .addClass('col')
                .text('Add to Cart')
                .on('click', function (e) {
                    e.preventDefault();
                    if (departureDateReturn) {
                        showAvailableFlights(destination, origin, departureDateReturn, adults, children, infants, null, flight.flight_id);
                    }
                    else {
                        $.ajax({
                            type: 'POST',
                            url: 'php/save_or_book_flight.php',
                            data: {
                                departureFlightId: firstFlightId ? firstFlightId : flight.flight_id,
                                returnFlightId: firstFlightId ? flight.flight_id : null,
                                adults: adults,
                                children: children,
                                infants: infants,
                                action: 'save'
                            },
                            success: function () {
                                alert('Added to Cart!');
                            }
                        });
                    }
                });

            $('#available-flights').append(
                $('<div></div>').addClass('card flight-card').append(
                    $('<h2></h2>').text(`${flight.origin} to ${flight.destination}`),
                    cardRow('Departure', `${flight.departure_time} ${flight.departure_date}`),
                    cardRow('Arrival', `${flight.arrival_time} ${flight.arrival_date}`),
                    cardRow('Available Seats', flight.available_seats),
                    cardRow('Price', `$${flight.price}`),
                    cardRow('ID', flight.flight_id),
                    $('<div></div>').addClass('row').append(addToCartButton)
                )
            );
        }
    });
};

$(document).ready(function () {
    $('#flight-info').hide();
    $('#departure-date-return').prop('disabled', true);
    $('#trip-type').on('change', function () {
        if ($(this).val() === 'roundtrip') {
            $('#returning input').prop('disabled', false);
            $('#returning').show();
        }
        else {
            $('#returning input').prop('disabled', true);
            $('#returning').hide();
        }
    });

    $('#flight-form').on('submit', function (event) {
        event.preventDefault();

        const origin = $('#origin').val().trim();
        const destination = $('#destination').val().trim();
        const departureDateLeave = new Date($('#departure-date-leave').val().replace(/-/g, '/'));

        const categoriesChecked = $('#passengers input:checked').length;
        const adults = parseInt($('#adults').val()) || 0;
        const children = parseInt($('#children').val()) || 0;
        const infants = parseInt($('#infants').val()) || 0;

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validCities.includes(origin) || !validCities.includes(destination) ?
            'Origin and destination must be a city in Texas or California.' :
            !validDate(departureDateLeave) ?
                'Departure date must be between Sep 1, 2024 and Dec 1, 2024.' :
                categoriesChecked < 1 ?
                    'At least one passenger type must be selected.' :
                    adults + children + infants < 1 ?
                        'Number of passengers must be at least 1.' :
                        adults > 4 || children > 4 || infants > 4 ?
                            'Number of passengers for each category cannot be more than 4.' :
                            false;

        var roundTripDetails = {};
        var departureDateReturn = null;
        if ($('#trip-type').val() === 'roundtrip') {
            departureDateReturn = new Date($('#departure-date-return').val().replace(/-/g, '/'));

            error = error || (
                !validDate(departureDateReturn) ?
                    'Departure date must be between Sep 1, 2024 and Dec 1, 2024.' :
                    false
            );

            roundTripDetails = {
                'Return Departure Date': departureDateReturn.toLocaleDateString(),
            };
        }

        if (error) {
            $('#error').text(error);
            $('#flight-info').hide();
        }
        else {
            $('#error').text('');
            const flightDetails = {
                'Trip Type': $('#trip-type :selected').text(),
                'Origin': origin,
                'Destination': destination,
                'Departure Date': departureDateLeave.toLocaleDateString(),
                ...roundTripDetails,
                'Adults': adults,
                'Children': children,
                'Infants': infants
            };

            let tableHtml = '';
            for (const key in flightDetails) {
                tableHtml += `
                    <tr>
                        <td>${key}:</td>
                        <td>${flightDetails[key]}</td>
                    </tr>
                `;
            }

            $('#flight-info').html(tableHtml);
            $('#flight-info').show();

            showAvailableFlights(origin, destination, departureDateLeave, adults, children, infants, departureDateReturn);
        }
    });
});