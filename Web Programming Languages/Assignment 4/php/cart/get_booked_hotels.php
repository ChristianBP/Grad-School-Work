<?php

require '../db.php';

$hotel_bookings = $connection->query(
    "SELECT *
    FROM hotel_booking
    NATURAL JOIN hotels"
)->fetch_all(MYSQLI_ASSOC);

foreach ($hotel_bookings as $key => $booking) {
    $adults = $connection->query(
        "SELECT *
        FROM guests
        WHERE hotel_booking_id = '{$booking['hotel_booking_id']}'
        AND category = 'Adult'"
    )->fetch_all(MYSQLI_ASSOC);

    $children = $connection->query(
        "SELECT *
        FROM guests
        WHERE hotel_booking_id = '{$booking['hotel_booking_id']}'
        AND category = 'Child'"
    )->fetch_all(MYSQLI_ASSOC);

    $infants = $connection->query(
        "SELECT *
        FROM guests
        WHERE hotel_booking_id = '{$booking['hotel_booking_id']}'
        AND category = 'Infant'"
    )->fetch_all(MYSQLI_ASSOC);

    $hotel_bookings[$key]['adults'] = count($adults);
    $hotel_bookings[$key]['children'] = count($children);
    $hotel_bookings[$key]['infants'] = count($infants);
    $hotel_bookings[$key]['guests'] = [...$adults, ...$children, ...$infants];
}

echo json_encode($hotel_bookings);

?>