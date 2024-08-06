<?php

require 'db.php';

$city = $_GET['city'];

$query = "SELECT * FROM hotels";
if (!empty($city)) {
    $query .= " WHERE city = '$city'";
}

echo json_encode($connection->query($query)->fetch_all(MYSQLI_ASSOC));

?>