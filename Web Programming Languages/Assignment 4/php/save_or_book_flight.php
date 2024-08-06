<?php

require 'db.php';

function createBooking($connection, $flightId, $bookingId, $adults, $children, $infants, $return_flight = "FALSE") {
    $totalPrice = 0;
    $price = $connection->query(
        "SELECT price FROM flights WHERE flight_id='$flightId'"
    )->fetch_assoc()['price'];

    $connection->query(
        "INSERT INTO flight_booking
            (flight_id, flight_booking_id, total_price, return_flight)
        VALUES
            ('$flightId', '$bookingId', '$totalPrice', $return_flight)"
    );

    foreach ($_POST['passengers'] as $passengerData) {
        $ticketPrice = $passengerData['category'] == 'Adult'
            ? $price
            : ($passengerData['category'] == 'Child'
                ? $price * 0.7
                : $price * 0.1);

        $ticketId = uniqid();
        $passenger_ssn = $passengerData['ssn'];
        $connection->query(
            "INSERT INTO tickets
                (ticket_id, flight_booking_id, ssn, price)
            VALUES
                ('$ticketId', '$bookingId', $passenger_ssn, $ticketPrice)"
        );

        $totalPrice += (float) $ticketPrice;
    }

    $connection->query(
        "UPDATE flight_booking
        SET total_price = $totalPrice
        WHERE flight_id='$flightId'
        AND flight_booking_id='$bookingId'"
    );

    $connection->query(
        "UPDATE flights
        SET available_seats = available_seats - ($adults + $children + $infants)
        WHERE flight_id='$flightId'"
    );
}

$departureFlightId = $_POST['departureFlightId'];
$adults = (int) $_POST['adults'];
$children = (int) $_POST['children'];
$infants = (int) $_POST['infants'];
$action = $_POST['action'];

if($action == 'save') {
    $xmlFile = '../xml_data/saved-flights.xml';

    $flights = file_exists($xmlFile)
    ? simplexml_load_file($xmlFile)
    : new SimpleXMLElement('<flights></flights>');

    $flight = $flights->addChild('flight');
    $flight->addChild('departure-flight-id', $departureFlightId);
    $flight->addChild('adults', $adults);
    $flight->addChild('children', $children);
    $flight->addChild('infants', $infants);
    $flight->addChild('saving-number', uniqid());

    if (!empty($_POST['returnFlightId'])) {
        $flight->addChild('return-flight-id', $_POST['returnFlightId']);
    }

    $flights->asXML($xmlFile);
} else {
    foreach ($_POST['passengers'] as $passengerData) {
        $connection->query(
            "INSERT INTO passenger
                (ssn, first_name, last_name, date_of_birth, category)
            VALUES
                ('$passengerData[ssn]', '$passengerData[firstname]', '$passengerData[lastname]', '$passengerData[dateofbirth]', '$passengerData[category]')
            ON DUPLICATE KEY UPDATE
                first_name='$passengerData[firstname]', last_name='$passengerData[lastname]', date_of_birth='$passengerData[dateofbirth]', category='$passengerData[category]'"
        );
    }

    $bookingId = uniqid();
    createBooking(
        $connection,
        $departureFlightId,
        $bookingId,
        $adults,
        $children,
        $infants
    );

    if (!empty($_POST['returnFlightId'])) {
        createBooking(
            $connection,
            $_POST['returnFlightId'],
            $bookingId,
            $adults,
            $children,
            $infants,
            "TRUE"
        );
    }

    $savingNumber = $_POST['savingNumber'];
    $savedFlightsData = simplexml_load_file('../xml_data/saved-flights.xml');
    $savedFlightData = $savedFlightsData->xpath("//flight[departure-flight-id='$departureFlightId' and saving-number='$savingNumber']")[0];
    unset($savedFlightData[0]);
    $savedFlightsData->asXML('../xml_data/saved-flights.xml');
}


?>