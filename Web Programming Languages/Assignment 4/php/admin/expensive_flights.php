<?php

require '../db.php';

$expensive_flights = $connection->query(
    "SELECT DISTINCT flights.*
    FROM flight_booking
    NATURAL JOIN flights
    ORDER BY price DESC
    LIMIT 3"
)->fetch_all(MYSQLI_ASSOC);

$flightHTML = "<div>";
foreach ($expensive_flights as $flight) {
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