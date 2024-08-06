<?php

require '../db.php';

$hotels = $connection->query(
    "SELECT DISTINCT hotels.*
    FROM hotel_booking
    NATURAL JOIN hotels
    WHERE check_in_date >= '2024-09-01'
    AND check_out_date <= '2024-09-30'"
)->fetch_all(MYSQLI_ASSOC);

$hotelHTML = "<div>";
foreach ($hotels as $hotel) {
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