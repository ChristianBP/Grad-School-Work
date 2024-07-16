import { validCities } from './locations.js';
import { cardRow } from './utils.js';

const showAvailableHotels = (city) => {
    const xhttp = new XMLHttpRequest();
    xhttp.open('GET', 'json_data/available-hotels.json', true);
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            const hotels = JSON.parse(this.responseText).hotels;
            const filteredHotels = hotels.filter(hotel => hotel.city === city);

            if (filteredHotels.length === 0) {
                $('#available-hotels').text('No hotels available.');
                return;
            }

            $('#available-hotels').empty();
            for (const hotel of filteredHotels) {
                $('#available-hotels').append(
                    $('<div></div>').addClass('card stay-card').append(
                        $('<h2></h2>').text(`${hotel.hotel_name}`),
                        cardRow('City', hotel.city),
                        cardRow('Price Per Night', `$${hotel.price_per_night}`),
                        cardRow('ID', hotel.hotel_id),
                        $('<div></div>').addClass('row').append(
                            $('<button></button>').addClass('col').text('Add to Cart')
                        )
                    )
                );
            }
        }
    };
    xhttp.send();
};

$(document).ready(function() {
    $('#stay-info').hide();

    $('#stay-form').on('submit', function(event) {
        event.preventDefault();

        const city = $('#city').val().trim();
        const checkInDate = new Date($('#check-in-date').val().replace(/-/g, '/'));
        const checkOutDate = new Date($('#check-out-date').val().replace(/-/g, '/'));
        const adults = parseInt($('#adults').val()) || 0;
        const children = parseInt($('#children').val()) || 0;
        const infants = parseInt($('#infants').val()) || 0;
        const numRooms =  Math.ceil( (adults + children + (adults < 1 ? infants : 0)) / 2 );

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validCities.includes(city) ?
                'City must be a city in Texas or California.' :
            !validDate(checkInDate) || !validDate(checkOutDate) ?
                'Check-in and check-out dates must be between Sep 1, 2024 and Dec 1, 2024.' :
            adults + children + infants < 1 ?
                'Number of guests must be at least 1.' :
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

            showAvailableHotels(city);
        }
    });
});