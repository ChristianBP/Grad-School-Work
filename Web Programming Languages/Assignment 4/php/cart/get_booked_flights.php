<?php

require '../db.php';

$departures = $connection->query(
    "SELECT *
    FROM flight_booking
    NATURAL JOIN flights
    WHERE flight_booking.return_flight = 0"
)->fetch_all(MYSQLI_ASSOC);

$flightData = array();

foreach ($departures as $departure) {
    $passengers = $connection->query(
        "SELECT *
        FROM passenger
        WHERE ssn IN (
            SELECT DISTINCT ssn
            FROM tickets
            WHERE flight_booking_id = '{$departure['flight_booking_id']}'
        )"
    )->fetch_all(MYSQLI_ASSOC);

    foreach ($passengers as $key => $passenger) {
        $passengers[$key]['tickets'] = $connection->query(
            "SELECT ticket_id, price
            FROM tickets
            WHERE ssn = '{$passenger['SSN']}'
            AND flight_booking_id = '{$departure['flight_booking_id']}'"
        )->fetch_all(MYSQLI_ASSOC);
    }

    $returning = $connection->query(
        "SELECT *
        FROM flight_booking
        NATURAL JOIN flights
        WHERE flight_booking_id = '{$departure['flight_booking_id']}'
        AND return_flight = 1"
    )->fetch_assoc();

    $flightData[] = array(
        'departure' => $departure,
        'passengers' => $passengers,
        'returning' => $returning
    );
}

echo json_encode($flightData);

?>