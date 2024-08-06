<?php

require '../db.php';

$connection->query("DELETE FROM guests");
$connection->query("DELETE FROM hotel_booking");
$connection->query("DELETE FROM hotels");

$hotels = json_decode(file_get_contents('../../json_data/hotels.json'), true);
$insertHotel = $connection->prepare(
    "INSERT INTO hotels
        (hotel_id, hotel_name, city, price_per_night)
    VALUES
        (?, ?, ?, ?)"
);

foreach ($hotels as $hotel) {
    $insertHotel->bind_param("issi", $hotel['hotel_id'], $hotel['hotel_name'], $hotel['city'], $hotel['price_per_night']);
    $insertHotel->execute();
}

?>