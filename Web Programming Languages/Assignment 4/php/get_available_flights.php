<?php

require 'db.php';

$origin = $_GET['origin'];
$destination = $_GET['destination'];
$departureDate = new DateTime($_GET['departureDate']);
$adults = $_GET['adults'];
$children = $_GET['children'];
$infants = $_GET['infants'];

$flightData = $connection->query(
    "SELECT *
    FROM flights
    WHERE origin = '$origin'
    AND destination = '$destination'
    AND available_seats >= $adults + $children + $infants
    AND departure_date = '{$departureDate->format('Y-m-d')}'
")->fetch_all(MYSQLI_ASSOC);

if (count($flightData) === 0) {
    $threeDaysBefore = clone $departureDate;
    $threeDaysBefore->sub(new DateInterval('P3D'));
    $threeDaysAfter = clone $departureDate;
    $threeDaysAfter->add(new DateInterval('P3D'));

    $flightData = $connection->query(
        "SELECT *
        FROM flights
        WHERE origin = '$origin'
        AND destination = '$destination'
        AND available_seats >= $adults + $children + $infants
        AND departure_date >= '{$threeDaysBefore->format('Y-m-d')}'
        AND departure_date <= '{$threeDaysAfter->format('Y-m-d')}'"
    )->fetch_all(MYSQLI_ASSOC);
}

echo json_encode($flightData);

?>