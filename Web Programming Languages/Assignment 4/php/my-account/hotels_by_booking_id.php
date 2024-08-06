<?php

require '../db.php';

$bookingId = $_GET['bookingId'];

$hotels = $connection->query(
    "SELECT DISTINCT hotels.*
    FROM hotel_booking
    NATURAL JOIN hotels
    WHERE hotel_booking_id = '$bookingId'"
)->fetch_all(MYSQLI_ASSOC);

$hotelHTML = "<div>";
if (empty($hotels)) {
    $hotelHTML .= "<p>No hotels found</p>";
}
else {
    foreach ($hotels as $hotel) {
        $hotelHTML = $hotelHTML
            . "<h3>" . $hotel['hotel_name'] . "</h3>"
            . "<p>" . "Hotel ID: " . $hotel['hotel_id'] . "</p>"
            . "<p>" . "City: " . $hotel['city'] . "</p>"
            . "<p>" . "Price Per Night: $" . $hotel['price_per_night'] . "</p>"
            . "<hr>";
    }
}
$hotelHTML .= "</div>";
echo $hotelHTML;

?>