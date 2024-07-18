<?php

$flightId = $_POST['flightId'];
$adults = (int) $_POST['adults'];
$children = (int) $_POST['children'];
$infants = (int) $_POST['infants'];
$action = $_POST['action'];

if ($action == 'save') {
    $xmlFile = '../xml_data/saved-flights.xml';
} else {
    $xmlFile = '../xml_data/booked-flights.xml';
}

$flights = file_exists($xmlFile)
    ? simplexml_load_file($xmlFile)
    : new SimpleXMLElement('<flights></flights>');

$flight = $flights->addChild('flight');
$flight->addChild('flight-id', $flightId);
$flight->addChild('adults', $adults);
$flight->addChild('children', $children);
$flight->addChild('infants', $infants);

if($action == 'save') {
    $flight->addChild('saving-number', uniqid());
} else {
    $flight->addChild('booking-number', uniqid());
    $passengers = $flight->addChild('passengers');

    $passengersData = $_POST['passengers'];

    foreach ($passengersData as $passengerData) {
        $passenger = $passengers->addChild('passenger');
        foreach($passengerData as $key => $value) {
            $passenger->addChild($key, $value);
        }
    }

    $flightsData = simplexml_load_file('../xml_data/flights.xml');
    $flightData = $flightsData->xpath("/flights/flight[flight-id='$flightId']")[0];
    $flightData->{'available-seats'} = ((int) $flightData->{'available-seats'}) - ($adults + $children + $infants);
    $flightsData->asXML('../xml_data/flights.xml');

    $savingNumber = $_POST['savingNumber'];
    $savedFlightsData = simplexml_load_file('../xml_data/saved-flights.xml');
    $savedFlightData = $savedFlightsData->xpath("/flights/flight[flight-id='$flightId' and saving-number='$savingNumber']")[0];
    unset($savedFlightData[0]);

    $savedFlightsData->asXML('../xml_data/saved-flights.xml');
}

$flights->asXML($xmlFile);

?>