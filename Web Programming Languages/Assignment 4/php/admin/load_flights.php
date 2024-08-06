<?php

require '../db.php';

$connection->query("DELETE FROM tickets");
$connection->query("DELETE FROM passenger");
$connection->query("DELETE FROM flight_booking");
$connection->query("DELETE FROM flights");

$xml = simplexml_load_file("../../xml_data/flights.xml");

foreach ($xml->flight as $flight) {
    $flightId = $flight->{'flight-id'};
    $origin = $flight->origin;
    $destination = $flight->destination;
    $departureDate = $flight->{'departure-date'};
    $arrivalDate = $flight->{'arrival-date'};
    $departureTime = $flight->{'departure-time'};
    $arrivalTime = $flight->{'arrival-time'};
    $availableSeats = $flight->{'available-seats'};
    $price = $flight->price;

    $connection->query(
        "INSERT INTO flights
            (flight_id, origin, destination, departure_date, arrival_date, departure_time, arrival_time, available_seats, price)
        VALUES
            ('$flightId', '$origin', '$destination', '$departureDate', '$arrivalDate', '$departureTime', '$arrivalTime', '$availableSeats', '$price')"
    );
}

?>