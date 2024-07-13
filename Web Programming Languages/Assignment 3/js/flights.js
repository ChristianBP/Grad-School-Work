import { validCities } from './locations.js';

const flightRow = (label, value) => {
    const row = document.createElement('div');
    row.classList.add('row');
    const header = document.createElement('h3');
    header.classList.add('col');
    header.textContent = label;
    const data = document.createElement('div');
    data.classList.add('col');
    data.textContent = value;
    row.appendChild(header);
    row.appendChild(data);
    return row;
};

const showAvailableFlights = (origin, destination, departureDate, passengerCount) => {
    document.getElementById('available-flights').textContent = '';
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'xml_data/flights.xml', true);
    xhttp.onreadystatechange = function() {
        if (this.readyState === 4 && this.status === 200) {
            const flights = this.responseXML.getElementsByTagName('flight');

            const flightData = Array.from(flights).map(flight => ({
                'origin': flight.querySelector('origin').textContent,
                'destination': flight.querySelector('destination').textContent,
                'departureDate': flight.querySelector('departure-date').textContent,
                'arrivalDate': flight.querySelector('arrival-date').textContent,
                'departureTime': flight.querySelector('departure-time').textContent,
                'arrivalTime': flight.querySelector('arrival-time').textContent,
                'availableSeats': flight.querySelector('available-seats').textContent,
                'price': flight.querySelector('price').textContent,
                'flightId': flight.querySelector('flight-id').textContent,
            }));

            let threeDaysBefore = new Date(departureDate);
            threeDaysBefore.setDate(departureDate.getDate() - 3);
            let threeDaysAfter = new Date(departureDate);
            threeDaysAfter.setDate(departureDate.getDate() + 3);

            let filteredFlightData = flightData.filter(flight =>
                flight.origin === origin &&
                flight.destination === destination &&
                flight.departureDate === departureDate.toLocaleDateString() &&
                flight.availableSeats >= passengerCount
            );

            if (filteredFlightData.length === 0) {
                filteredFlightData = flightData.filter(flight =>
                    flight.origin === origin &&
                    flight.destination === destination &&
                    new Date(flight.departureDate) >= threeDaysBefore &&
                    new Date(flight.departureDate) <= threeDaysAfter &&
                    flight.availableSeats >= passengerCount
                );
            }

            if (filteredFlightData.length === 0) {
                document.getElementById('available-flights').textContent = 'No flights available.';
                return;
            }

            for (const flight of filteredFlightData) {
                const flightCard = document.createElement('div');
                flightCard.classList.add('flight-card');

                const h2 = document.createElement('h2');
                h2.textContent = `${flight.origin} to ${flight.destination}`;

                const buttonRow = document.createElement('div');
                buttonRow.classList.add('row');
                const addButton = document.createElement('button');
                addButton.classList.add('col');
                addButton.textContent = 'Add to Cart';
                buttonRow.appendChild(addButton);

                flightCard.appendChild(h2);
                flightCard.appendChild(flightRow('Departure', `${flight.departureTime} ${flight.departureDate}`));
                flightCard.appendChild(flightRow('Arrival', `${flight.arrivalTime} ${flight.arrivalDate}`));
                flightCard.appendChild(flightRow('Available Seats', flight.availableSeats));
                flightCard.appendChild(flightRow('Price', `$${flight.price}`));
                flightCard.appendChild(flightRow('ID', flight.flightId));

                flightCard.appendChild(buttonRow);

                document.getElementById('available-flights').appendChild(flightCard);
            }
        }
    };
    xhttp.send();
};

$(document).ready(function() {
    $('#flight-info').hide();
    $('#departure-date-return').prop('disabled', true);
    $('#trip-type').on('change', function() {
        if ($(this).val() === 'roundtrip') {
            $('#returning input').prop('disabled', false);
            $('#returning').show();
        }
        else {
            $('#returning input').prop('disabled', true);
            $('#returning').hide();
        }
    });

    $('#flight-form').on('submit', function(event) {
        event.preventDefault();

        const origin = $('#origin').val().trim();
        const destination = $('#destination').val().trim();
        const departureDateLeave = new Date($('#departure-date-leave').val().replace(/-/g, '/'));

        const categoriesChecked = $('#passengers input:checked').length;
        const adults = parseInt($('#adults').val()) || 0;
        const children = parseInt($('#children').val()) || 0;
        const infants = parseInt($('#infants').val()) || 0;
        const passengerCount = adults + children + infants;

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validCities.includes(origin) || !validCities.includes(destination) ?
                'Origin and destination must be a city in Texas or California.' :
            !validDate(departureDateLeave) ?
                'Departure date must be between Sep 1, 2024 and Dec 1, 2024.' :
            categoriesChecked === 0 ?
                'At least one passenger type must be selected.' :
            passengerCount === 0 ?
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

            showAvailableFlights(origin, destination, departureDateLeave, passengerCount);
        }
    });

    $('#passengers-icon').click(function() {
        $('#passengers').toggle();
    });

    $('#adults-toggle').click(function() {
        $('.adults').toggle();
    });

    $('#children-toggle').change(function() {
        $('.children').toggle();
    });

    $('#infants-toggle').change(function() {
        $('.infants').toggle();
    });
});