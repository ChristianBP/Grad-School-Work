CREATE TABLE flights (
    flight_id INT(11) PRIMARY KEY,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_date DATE NOT NULL,
    arrival_date DATE NOT NULL,
    departure_time VARCHAR(5) NOT NULL,
    arrival_time VARCHAR(5) NOT NULL,
    available_seats INT(11) NOT NULL,
    price INT(11) NOT NULL
)

CREATE TABLE Passenger (
    SSN INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    category VARCHAR(8)
);

CREATE TABLE Flight_Booking (
    flight_booking_id VARCHAR(50),
    flight_id INT,
    total_price DECIMAL(10, 2),
    return_flight BOOLEAN,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    PRIMARY KEY (flight_booking_id, return_flight)
);

CREATE TABLE Tickets (
    ticket_id VARCHAR(50) PRIMARY KEY,
    flight_booking_id VARCHAR(50),
    SSN INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (SSN) REFERENCES Passenger(SSN),
    FOREIGN KEY (flight_booking_id) REFERENCES Flight_Booking(flight_booking_id)
);