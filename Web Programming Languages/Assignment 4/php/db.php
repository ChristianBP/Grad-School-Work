<?php

$connection = mysqli_connect("localhost", "travel_admin", "password", "travel_deals");

if (!$connection) {
    die("Connection failed: " . mysqli_connect_error());
}

?>