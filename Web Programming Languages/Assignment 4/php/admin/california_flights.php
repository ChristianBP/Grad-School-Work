<?php

require '../db.php';
require '../locations.php';

$result = $connection->query(
    "SELECT COUNT(DISTINCT flight_id) AS num_booked_flights
    FROM flights
    NATURAL JOIN flight_booking
    WHERE (arrival_date BETWEEN '2024-09-01' AND '2024-10-31')
    AND destination IN $CALIFORNIA_CITIES"
);

$numBookedFlights = $result->fetch_assoc()['num_booked_flights'];

echo "<h3>$numBookedFlights</h3>";

?>