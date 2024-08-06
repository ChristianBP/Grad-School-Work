<?php

require 'db.php';

$bookingId = $_GET['bookingId'];

$ssns = $connection->query("SELECT DISTINCT ssn FROM Tickets WHERE flight_booking_id = '$bookingId'");
$passengers = array();

while ($ssn = $ssns->fetch_assoc()) {
    $passenger = array();
    $passenger['ssn'] = $ssn['ssn'];

    $passengerResult = $connection->query("SELECT * FROM Passenger WHERE ssn = '{$ssn['ssn']}'")->fetch_assoc();

    $passenger['first_name'] = $passengerResult['first_name'];
    $passenger['last_name'] = $passengerResult['last_name'];
    $passenger['date_of_birth'] = $passengerResult['date_of_birth'];
    $passenger['category'] = $passengerResult['category'];

    $ticketsResult = $connection->query("SELECT * FROM Tickets WHERE ssn = '{$ssn['ssn']}' AND flight_booking_id = '$bookingId'");
    $tickets = array();

    while ($ticketRow = $ticketsResult->fetch_assoc()) {
        $ticket = array();
        $ticket['ticket_id'] = $ticketRow['ticket_id'];
        $ticket['price'] = $ticketRow['price'];

        $tickets[] = $ticket;
    }

    $passenger['tickets'] = $tickets;
    $passengers[] = $passenger;
}

echo json_encode($passengers);

?>