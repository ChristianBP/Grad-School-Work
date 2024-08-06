CREATE TABLE Users (
    phoneNumber VARCHAR(12) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    dateOfBirth DATE NOT NULL,
    email VARCHAR(100) NOT NULL,
    gender VARCHAR(6)
);

INSERT INTO Users (
    phoneNumber, password, firstName, lastName, dateOfBirth, email, gender
) VALUES (
    '222-222-2222', 'password', 'Admin', 'User', '2024-07-31', 'admin@user.com', ''
);