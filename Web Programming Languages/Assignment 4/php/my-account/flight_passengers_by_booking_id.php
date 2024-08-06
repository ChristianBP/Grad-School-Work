<?php

require '../db.php';

$bookingId = $_GET['bookingId'];

$passengers = $connection->query(
    "SELECT DISTINCT passenger.*
    FROM passenger
    NATURAL JOIN tickets
    WHERE flight_booking_id = '$bookingId'"
)->fetch_all(MYSQLI_ASSOC);

$passengerHTML = "<div>";
if (empty($passengers)) {
    $passengerHTML .= "<p>No passengers found</p>";
}
else {
    foreach ($passengers as $passenger) {
        $passengerHTML = $passengerHTML
            . "<h3>" . $passenger['first_name'] . " " . $passenger['last_name'] . "</h3>"
            . "<p>" . "SSN: " . $passenger['SSN'] . "</p>"
            . "<p>" . "Date of Birth: " . $passenger['date_of_birth'] . "</p>"
            . "<p>" . "Category: " . $passenger['category'] . "</p>"
            . "<hr>";
    }
}
$passengerHTML .= "</div>";
echo $passengerHTML;

?>