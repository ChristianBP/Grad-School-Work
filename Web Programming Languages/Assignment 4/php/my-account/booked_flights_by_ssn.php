<?php

require '../db.php';

$ssn = $_GET['ssn'];

$booked_flights = $connection->query(
    "SELECT DISTINCT flights.*
    FROM passenger
    NATURAL JOIN tickets
    NATURAL JOIN flight_booking
    JOIN flights ON flights.flight_id = flight_booking.flight_id
    WHERE SSN = '$ssn'"
)->fetch_all(MYSQLI_ASSOC);

$flightHTML = "<div>";
foreach ($booked_flights as $flight) {
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