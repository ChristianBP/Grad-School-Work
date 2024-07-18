import { validCities } from './locations.js';
import { cardRow } from './utils.js';

const showAvailableFlights = (origin, destination, departureDate, adults, children, infants) => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/flights.xml', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            let flightData = $(this.responseXML).find('flight').toArray().map(
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

            flightData = flightData.filter(flight =>
                flight.origin === origin &&
                flight.destination === destination &&
                flight.availableSeats >= adults + children + infants
            );

            let filteredFlightData = flightData.filter(flight =>
                flight.departureDate === departureDate.toLocaleDateString()
            );

            if (filteredFlightData.length === 0) {
                let threeDaysBefore = new Date(departureDate);
                threeDaysBefore.setDate(departureDate.getDate() - 3);
                let threeDaysAfter = new Date(departureDate);
                threeDaysAfter.setDate(departureDate.getDate() + 3);

                filteredFlightData = flightData.filter(flight =>
                    new Date(flight.departureDate) >= threeDaysBefore &&
                    new Date(flight.departureDate) <= threeDaysAfter
                );
            }

            if (filteredFlightData.length === 0) {
                $('#available-flights').text('No flights available.');
                return;
            }

            $('#available-flights').empty();
            for (const flight of filteredFlightData) {
                const addToCartButton = $('<button></button>')
                    .addClass('col')
                    .text('Add to Cart')
                    .on('click', function (e) {
                        e.preventDefault();
                        $.ajax({
                            type: 'POST',
                            url: 'php/save_or_book_flight.php',
                            data: {
                                flightId: flight.flightId,
                                adults: adults,
                                children: children,
                                infants: infants,
                                action: 'save'
                            },
                            success: function () {
                                alert('Added to Cart!');
                            }
                        });
                    });

                $('#available-flights').append(
                    $('<div></div>').addClass('card flight-card').append(
                        $('<h2></h2>').text(`${flight.origin} to ${flight.destination}`),
                        cardRow('Departure', `${flight.departureTime} ${flight.departureDate}`),
                        cardRow('Arrival', `${flight.arrivalTime} ${flight.arrivalDate}`),
                        cardRow('Available Seats', flight.availableSeats),
                        cardRow('Price', `$${flight.price}`),
                        cardRow('ID', flight.flightId),
                        $('<div></div>').addClass('row').append(addToCartButton)
                    )
                );
            }
        }
    };
    xhttp.send();
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

        if ($('#trip-type').val() === 'roundtrip') {
            const departureDateReturn = new Date($('#departure-date-return').val().replace(/-/g, '/'));

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

            showAvailableFlights(origin, destination, departureDateLeave, adults, children, infants);
        }
    });
});