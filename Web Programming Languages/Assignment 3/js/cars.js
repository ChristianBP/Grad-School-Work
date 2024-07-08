import { validCities } from './locations.js';

$(document).ready(function() {
    $('#car-info').hide();

    $('#car-form').on('submit', function(event) {
        event.preventDefault();

        const city = $('#city').val().trim();
        const checkInDate = new Date($('#check-in-date').val().replace(/-/g, '/'));
        const checkOutDate = new Date($('#check-out-date').val().replace(/-/g, '/'));

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validCities.includes(city) ?
                'Origin and destination must be a city in Texas or California.' :
            !validDate(checkInDate) || !validDate(checkOutDate) ?
                'Check-in and check-out dates must be between Sep 1, 2024 and Dec 1, 2024.' :
            false;

        if (error) {
            $('#error').text(error);
            $('#car-info').hide();
        }
        else {
            $('#error').text('');
            const carDetails = {
                'City': city,
                'Car Type': $('#car-type :selected').text(),
                'Check-in Date': checkInDate.toLocaleDateString(),
                'Check-out Date': checkOutDate.toLocaleDateString()
            };

            let tableHtml = '';
            for (const key in carDetails) {
                tableHtml += `
                    <tr>
                        <td>${key}:</td>
                        <td>${carDetails[key]}</td>
                    </tr>
                `;
            }

            $('#car-info').html(tableHtml);
            $('#car-info').show();
        }
    });
});