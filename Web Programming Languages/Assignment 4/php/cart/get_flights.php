<?php

require '../db.php';

$flights = $connection->query(
    "SELECT * FROM flights"
)->fetch_all(MYSQLI_ASSOC);

echo json_encode($flights);

?>