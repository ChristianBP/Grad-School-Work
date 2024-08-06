<?php

$userInfo = $_COOKIE['userInfo'];
$userData = json_decode($userInfo, true);
$phonenumber = $userData['phoneNumber'];
$firstname = $userData['firstName'];
$lastname = $userData['lastName'];
$dateOfBirth = $userData['dateOfBirth'];
$email = $userData['email'];
$gender = $userData['gender'];

$comment = $_POST['comment'];

$entries = file_exists('../xml_data/contact-us-entries.xml')
    ? simplexml_load_file('../xml_data/contact-us-entries.xml')
    : new SimpleXMLElement('<entries></entries>');

$entry = $entries->addChild('entry');
$entry->addChild('contact-id', uniqid());
$entry->addChild('phonenumber', $phonenumber);
$entry->addChild('firstname', $firstname);
$entry->addChild('lastname', $lastname);
$entry->addChild('date-of-birth', $dateOfBirth);
$entry->addChild('email', $email);
$entry->addChild('gender', $gender);
$entry->addChild('comment', $comment);

$entries->asXML('../xml_data/contact-us-entries.xml');

?>