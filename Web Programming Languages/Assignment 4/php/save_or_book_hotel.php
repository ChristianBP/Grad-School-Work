<?php

require 'db.php';

$hotelId = (int) $_POST['hotel_id'];
$checkInDate = $_POST['check_in_date'];
$checkOutDate = $_POST['check_out_date'];
$adults = (int) $_POST['adults'];
$children = (int) $_POST['children'];
$infants = (int) $_POST['infants'];
$numRooms = (int) $_POST['number_of_rooms'];
$action = $_POST['action'];

$savedHotelsFilename = '../json_data/saved-hotels.json';
if (file_exists($savedHotelsFilename)) {
    $hotels = json_decode(file_get_contents($savedHotelsFilename), true);
}

if ($action == 'save') {
    $hotels[] = [
        'hotel_id' => $hotelId,
        'check_in_date' => $checkInDate,
        'check_out_date' => $checkOutDate,
        'adults' => $adults,
        'children' => $children,
        'infants' => $infants,
        'number_of_rooms' => $numRooms,
        'saving_number' => uniqid()
    ];
} else {
    $price_per_night = $_POST['price_per_night'];
    $totalPrice = $_POST['total_price'];

    $bookingId = uniqid();

    $connection->query(
        "INSERT INTO hotel_booking
            (hotel_booking_id, hotel_id, check_in_date, check_out_date, number_of_rooms, price_per_night, total_price)
        VALUES
            ('$bookingId', $hotelId, '$checkInDate', '$checkOutDate', $numRooms, $price_per_night, $totalPrice)"
    );

    foreach ($_POST['guests'] as $guestData) {
        $connection->query(
            "INSERT INTO guests
                (ssn, hotel_booking_id, first_name, last_name, date_of_birth, category)
            VALUES
                ('$guestData[ssn]', '$bookingId', '$guestData[firstname]', '$guestData[lastname]', '$guestData[dateofbirth]', '$guestData[category]')
            ON DUPLICATE KEY UPDATE
                first_name='$guestData[firstname]', hotel_booking_id='$bookingId', last_name='$guestData[lastname]', date_of_birth='$guestData[dateofbirth]', category='$guestData[category]'"
        );
    }

    $savingNumber = $_POST['saving_number'];
    foreach ($hotels as $key => $hotelData) {
        if ($hotelData['hotel_id'] == $hotelId && $hotelData['saving_number'] == $savingNumber) {
            unset($hotels[$key]);
        }
    }
    $hotels = array_values($hotels);
}

file_put_contents($savedHotelsFilename, json_encode($hotels));

?>