<?php

require '../db.php';

$bookingId = $_GET['bookingId'];

$booked_flights = $connection->query(
    "SELECT DISTINCT flights.*
    FROM flight_booking
    NATURAL JOIN flights
    WHERE flight_booking_id = '$bookingId'"
)->fetch_all(MYSQLI_ASSOC);

$flightHTML = "<div>";
if (empty($booked_flights)) {
    $flightHTML .= "<p>No flights found</p>";
}
else {
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
}
$flightHTML .= "</div>";
echo $flightHTML;

?>