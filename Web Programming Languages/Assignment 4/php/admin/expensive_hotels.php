<?php

require '../db.php';

$expensive_hotels = $connection->query(
    "SELECT DISTINCT hotels.*
    FROM hotel_booking
    NATURAL JOIN hotels
    ORDER BY price_per_night DESC
    LIMIT 3"
)->fetch_all(MYSQLI_ASSOC);

$hotelHTML = "<div>";
foreach ($expensive_hotels as $hotel) {
    $hotelHTML = $hotelHTML
        . "<h3>" . $hotel['hotel_name'] . "</h3>"
        . "<p>" . "Hotel ID: " . $hotel['hotel_id'] . "</p>"
        . "<p>" . "City: " . $hotel['city'] . "</p>"
        . "<p>" . "Price Per Night: $" . $hotel['price_per_night'] . "</p>"
        . "<hr>";
}
$hotelHTML .= "</div>";
echo $hotelHTML;

?>