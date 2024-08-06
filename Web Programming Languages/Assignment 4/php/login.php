<?php

require 'db.php';

$phoneNumber = $_POST['phonenumber'];
$password = $_POST['password'];

$query = "SELECT phoneNumber, firstName, lastName, dateOfBirth, email, gender FROM Users WHERE phoneNumber = '$phoneNumber' AND password = '$password'";
$result = mysqli_query($connection, $query);

if (mysqli_num_rows($result) > 0) {
    $user = mysqli_fetch_assoc($result);
    setcookie('userInfo', json_encode($user), time() + (86400 * 30), '/');
    echo "success";
} else {
    echo "Invalid credentials";
}

?>