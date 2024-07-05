import { validCities } from './locations.js';

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
        const arrivalDateLeave = new Date($('#arrival-date-leave').val().replace(/-/g, '/'));

        const categoriesChecked = $('#passengers input:checked').length;
        const adults = parseInt($('#adults').val()) || 0;
        const children = parseInt($('#children').val()) || 0;
        const infants = parseInt($('#infants').val()) || 0;

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validCities.includes(origin) || !validCities.includes(destination) ?
                'Origin and destination must be a city in Texas or California.' :
            !validDate(departureDateLeave) || !validDate(arrivalDateLeave) ?
                'Departure and arrival dates must be between Sep 1, 2024 and Dec 1, 2024.' :
            categoriesChecked === 0 ?
                'At least one passenger type must be selected.' :
            adults + children + infants === 0 ?
                'Number of passengers must be at least 1.' :
            adults > 4 || children > 4 || infants > 4 ?
                'Number of passengers for each category cannot be more than 4.' :
            false;

        var roundTripDetails = {};

        if ($('#trip-type').val() === 'roundtrip') {
            const departureDateReturn = new Date($('#departure-date-return').val().replace(/-/g, '/'));
            const arrivalDateReturn = new Date($('#arrival-date-return').val().replace(/-/g, '/'));

            error = error || (
                !validDate(departureDateReturn) || !validDate(arrivalDateReturn) ?
                    'Departure and arrival dates must be between Sep 1, 2024 and Dec 1, 2024.' :
                false
            );

            roundTripDetails = {
                'Return Departure Date': departureDateReturn.toLocaleDateString(),
                'Return Arrival Date': arrivalDateReturn.toLocaleDateString()
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
                'Arrival Date': arrivalDateLeave.toLocaleDateString(),
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