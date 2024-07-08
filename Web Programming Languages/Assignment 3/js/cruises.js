$(document).ready(function() {
    $('#cruise-info').hide();

    $('#cruise-form').on('submit', function(event) {
        event.preventDefault();

        const departingAfter = new Date($('#departing-after').val().replace(/-/g, '/'));
        const departingBefore = new Date($('#departing-before').val().replace(/-/g, '/'));
        const minimumDuration = parseInt($('#minimum-duration').val()) || 0;
        const maximumDuration = parseInt($('#maximum-duration').val()) || 0;
        const numRooms = parseInt($('#num-rooms').val()) || 0;
        const numPassengers = parseInt($('#num-passengers').val()) || 0;

        const validDate = (date) => new Date('2024/09/01') <= date && date <= new Date('2024/12/01');

        var error = !validDate(departingAfter) || !validDate(departingBefore) ?
                'Departure must be between Sep 1, 2024 and Dec 1, 2024.' :
            minimumDuration < 3 || minimumDuration > 10 ?
                'Minimum duration must be between 3 and 10.' :
            maximumDuration < 3 || maximumDuration > 10 ?
                'Maximum duration must be between 3 and 10.' :
            numRooms < 1 ?
                'Number of rooms must be at least 1.' :
            numPassengers < 1 ?
                'Number of passengers must be at least 1.' :
            numPassengers / numRooms > 2 ?
                'Number of passengers cannot be more than 2 per room.' :
            false;

        if (error) {
            $('#error').text(error);
            $('#cruise-info').hide();
        }
        else {
            $('#error').text('');
            const cruiseDetails = {
                'Destination': $('#destination :selected').text(),
                'Departing Between': departingAfter.toLocaleDateString(),
                'And': departingBefore.toLocaleDateString(),
                'Duration Between': `${minimumDuration} and ${maximumDuration} days`,
                'Number of Rooms': numRooms,
                'Passengers': numPassengers
            };

            let tableHtml = '';
            for (const key in cruiseDetails) {
                tableHtml += `
                    <tr>
                        <td>${key}:</td>
                        <td>${cruiseDetails[key]}</td>
                    </tr>
                `;
            }

            $('#cruise-info').html(tableHtml);
            $('#cruise-info').show();
        }
    });
});