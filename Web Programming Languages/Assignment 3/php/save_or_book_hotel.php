<?php

$hotelId = (int) $_POST['hotel_id'];
$checkInDate = $_POST['check_in_date'];
$checkOutDate = $_POST['check_out_date'];
$adults = (int) $_POST['adults'];
$children = (int) $_POST['children'];
$infants = (int) $_POST['infants'];
$numRooms = (int) $_POST['num_rooms'];
$action = $_POST['action'];

if ($action == 'save') {
    $jsonFile = '../json_data/saved-hotels.json';
} else {
    $jsonFile = '../json_data/booked-hotels.json';

    $city = $_POST['city'];
    $hotel_name = $_POST['hotel_name'];
    $price_per_night = $_POST['price_per_night'];
    $totalPrice = $_POST['total_price'];
}

if (file_exists($jsonFile)) {
    $hotels = json_decode(file_get_contents($jsonFile), true);
}

$hotel = [
    'hotel_id' => $hotelId,
    'check_in_date' => $checkInDate,
    'check_out_date' => $checkOutDate,
    'adults' => $adults,
    'children' => $children,
    'infants' => $infants,
    'num_rooms' => $numRooms
];

if ($action == 'save') {
    $hotel['saving_number'] = uniqid();
} else {
    $hotel['city'] = $city;
    $hotel['hotel_name'] = $hotel_name;
    $hotel['price_per_night'] = $price_per_night;
    $hotel['total_price'] = $totalPrice;

    $savingNumber = $_POST['saving_number'];
    $savedHotelsData = json_decode(file_get_contents('../json_data/saved-hotels.json'), true);
    foreach ($savedHotelsData as $key => $hotelData) {
        if ($hotelData['hotel_id'] == $hotelId && $hotelData['saving_number'] == $savingNumber) {
            unset($savedHotelsData[$key]);
        }
    }
    $savedHotelsData = array_values($savedHotelsData);

    file_put_contents('../json_data/saved-hotels.json', json_encode($savedHotelsData));
}

$hotels[] = $hotel;
file_put_contents($jsonFile, json_encode($hotels));

?>