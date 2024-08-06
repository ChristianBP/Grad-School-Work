<?php
require 'db.php';

$query = "SELECT phoneNumber FROM Users";
$result = mysqli_query($connection, $query);

if ($result) {
    $phoneNumbers = array();

    while ($row = mysqli_fetch_assoc($result)) {
        $phoneNumbers[] = $row['phoneNumber'];
    }

    echo json_encode($phoneNumbers);
}

?>