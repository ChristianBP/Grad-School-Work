<?php

$firstname = $_POST['firstname'];
$lastname = $_POST['lastname'];
$phonenumber = $_POST['phonenumber'];
$email = $_POST['email'];
$gender = $_POST['gender'];
$comment = $_POST['comment'];

$entries = file_exists('../xml_data/contact-us-entries.xml')
    ? simplexml_load_file('../xml_data/contact-us-entries.xml')
    : new SimpleXMLElement('<entries></entries>');

$entry = $entries->addChild('entry');
$entry->addChild('firstname', $firstname);
$entry->addChild('lastname', $lastname);
$entry->addChild('phonenumber', $phonenumber);
$entry->addChild('email', $email);
$entry->addChild('gender', $gender);
$entry->addChild('comment', $comment);

$entries->asXML('../xml_data/contact-us-entries.xml');

?>