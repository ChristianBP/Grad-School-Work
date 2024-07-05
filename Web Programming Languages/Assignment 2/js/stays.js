import { validCities } from './locations.js';

$(document).ready(function() {
    $('#stay-info').hide();

    $('#stay-form').on('submit', function(event) {
        event.preventDefault();

        const city = $('#city').val().trim();
        const numRooms = parseInt($('#num-rooms').val()) || 0;
        const adults = parseInt($('#adults').val()) || 0;
        const children = parseInt($('#children').val()) || 0;
        const infants = parseInt($('#infants').val()) || 0;
        const checkInDate = new Date($('#check-in-date').val().replace(/-/g, '/'));
        const checkOutDate = new Date($('#check-out-date').val().replace(/-/g, '/'));

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validCities.includes(city) ?
                'City must be a city in Texas or California.' :
            !validDate(checkInDate) || !validDate(checkOutDate) ?
                'Check-in and check-out dates must be between Sep 1, 2024 and Dec 1, 2024.' :
            numRooms < 1 ?
                'Number of rooms must be at least 1.' :
            (adults + children + infants) < 1 ?
                'Number of guests must be at least 1.' :
            (adults + children + infants) / numRooms > 2 ?
                'Number of guests per room cannot be more than 2.' :
            false;

        if (error) {
            $('#error').text(error);
            $('#stay-info').hide();
        }
        else {
            $('#error').text('');
            const stayDetails = {
                'City': city,
                'Check-in Date': checkInDate.toLocaleDateString(),
                'Check-out Date': checkOutDate.toLocaleDateString(),
                'Number of Rooms': numRooms,
                'Adults': adults,
                'Children': children,
                'Infants': infants
            };

            let tableHtml = '';
            for (const key in stayDetails) {
                tableHtml += `
                    <tr>
                        <td>${key}:</td>
                        <td>${stayDetails[key]}</td>
                    </tr>
                `;
            }

            $('#stay-info').html(tableHtml);
            $('#stay-info').show();
        }
    });
});