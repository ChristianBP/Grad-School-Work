<?php

require 'db.php';

$phonenumber = $_POST['phonenumber'];
$firstname = $_POST['firstname'];
$lastname = $_POST['lastname'];
$email = $_POST['email'];
$dob = $_POST['dob'];
$password = $_POST['password'];
$gender = $_POST['gender'];

$connection->query(
    "INSERT INTO Users
        (phoneNumber, firstName, lastName, email, dateOfBirth, password, gender)
    VALUES
        ('$phonenumber', '$firstname', '$lastname', '$email', '$dob', '$password', '$gender')"
);

?>