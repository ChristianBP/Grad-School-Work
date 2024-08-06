CREATE TABLE hotels (
    hotel_id INT PRIMARY KEY,
    hotel_name VARCHAR(255),
    city VARCHAR(255),
    price_per_night INT
);

CREATE TABLE hotel_booking (
    hotel_booking_id VARCHAR(50) PRIMARY KEY,
    hotel_id INT,
    check_in_date DATE,
    check_out_date DATE,
    number_of_rooms INT,
    price_per_night INT,
    total_price INT,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

CREATE TABLE guests (
    ssn INT PRIMARY KEY,
    hotel_booking_id VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    category VARCHAR(8),
    FOREIGN KEY (hotel_booking_id) REFERENCES hotel_booking(hotel_booking_id)
);