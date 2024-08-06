<?php

require '../db.php';

$flights = $connection->query(
    "SELECT *
    FROM flights
    WHERE flight_id IN (
        (   SELECT flight_id
            FROM passenger
            NATURAL JOIN tickets
            NATURAL JOIN flight_booking
            WHERE category = 'Infant'
            GROUP BY flight_id, category
            HAVING COUNT(category) >= 1
        )
    )"
)->fetch_all(MYSQLI_ASSOC);

$flightHTML = "<div>";
foreach ($flights as $flight) {
    $flightHTML = $flightHTML
        . "<h3>" . $flight['origin'] . " to " . $flight['destination'] . "</h3>"
        . "<p>" . "Flight ID: " . $flight['flight_id'] . "</p>"
        . "<p>" . "Departure: " . $flight['departure_time'] . " " . $flight['departure_date'] . "</p>"
        . "<p>" . "Arrival: " . $flight['arrival_time'] . " " . $flight['arrival_date'] . "</p>"
        . "<p>" . "Available Seats: " . $flight['available_seats'] . "</p>"
        . "<p>" . "Price: $" . $flight['price'] . "</p>"
        . "<hr>";
}
$flightHTML .= "</div>";
echo $flightHTML;

?>