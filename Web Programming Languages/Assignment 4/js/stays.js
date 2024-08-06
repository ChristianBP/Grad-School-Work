import { validCities } from './locations.js';
import { cardRow } from './utils.js';

const showAvailableHotels = (city, checkInDate, checkOutDate, adults, children, infants, numRooms) => {
    $.get('php/get_hotels.php', { city: city }, function (data) {
        const hotels = JSON.parse(data);
        if (hotels.length === 0) {
            $('#available-hotels').text('No hotels available.');
            return;
        }

        $('#available-hotels').empty();
        for (const hotel of hotels) {
            const addToCartButton = $('<button></button>')
                .addClass('col')
                .text('Add to Cart')
                .on('click', function (e) {
                    e.preventDefault();
                    $.ajax({
                        type: 'POST',
                        url: 'php/save_or_book_hotel.php',
                        data: {
                            hotel_id: hotel.hotel_id,
                            check_in_date: checkInDate.toISOString().split('T')[0],
                            check_out_date: checkOutDate.toISOString().split('T')[0],
                            adults: adults,
                            children: children,
                            infants: infants,
                            number_of_rooms: numRooms,
                            action: 'save'
                        },
                        success: function () {
                            alert('Added to Cart!');
                        }
                    });
                });
            $('#available-hotels').append(
                $('<div></div>').addClass('card stay-card').append(
                    $('<h2></h2>').text(`${hotel.hotel_name}`),
                    cardRow('City', hotel.city),
                    cardRow('Price Per Night', `$${hotel.price_per_night}`),
                    cardRow('ID', hotel.hotel_id),
                    $('<div></div>').addClass('row').append(addToCartButton)
                )
            );
        }
    });
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
            checkInDate.getTime() >= checkOutDate.getTime() ?
                'Check-out date must be after check-in date.' :
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

            showAvailableHotels(city, checkInDate, checkOutDate, adults, children, infants, numRooms);
        }
    });
});