-- sqlite3 app.db < create_db.sql
-- sqlite3 app.db < populate_db.sql

CREATE TABLE IF NOT EXISTS apartment (
    apartment_id INTEGER PRIMARY KEY,
    apartment_name VARCHAR(50) NOT NULL,
    laundry_type INT, --1: onsite laundry; 2: in-unit laundry;
    parking_type INT, --1: street parking; 2: city-run parking lot; 3: apartment-run parking lot
    landlord_id INT,
    official_website TEXT,
    address TEXT NOT NULL,
    city VARCHAR(20) NOT NULL,
    state INT NOT NULL, -- only accepts FIPS code of the state, reference: https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
    zipcode CHAR(5) NOT NULL,
    latitude VARCHAR(20),
    longitude VARCHAR(20),
    FOREIGN KEY(landlord_id) REFERENCES landlord (landlord_id)
);

-- many to many relation
CREATE TABLE IF NOT EXISTS user_apartment_wishlist (
    email_address VARCHAR(30) NOT NULL,
    apartment_id INT NOT NULL,
    PRIMARY KEY(email_address, apartment_id),
    FOREIGN KEY(email_address) REFERENCES user (email_address),
    FOREIGN KEY(apartment_id) REFERENCES apartment (apartment_id)
);

CREATE TABLE IF NOT EXISTS worksite (
    worksite_id INT PRIMARY KEY,
    worksite_name VARCHAR(30) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(20) NOT NULL,
    state INT NOT NULL, -- only accepts FIPS code of the state, reference: https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
    zipcode CHAR(5) NOT NULL,
    latitude VARCHAR(20),
    longitude VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS user (
    email_address VARCHAR(30) PRIMARY KEY,
    user_password TEXT NOT NULL,
    worksite_id INT,
    age INT,
    FOREIGN KEY(worksite_id) REFERENCES worksite (worksite_id)
);

CREATE TABLE IF NOT EXISTS landlord (
    landlord_id INTEGER PRIMARY KEY,
    landlord_name VARCHAR(30) NOT NULL,
    landlord_rating FLOAT,
    landlord_rating_count INT
);

-- weak entity
CREATE TABLE IF NOT EXISTS floor_plan (
    apartment_id INT NOT NULL,
    floor_plan_id INT NOT NULL,
    floor_plan_type INT NOT NULL, --1: studio 2: 1b1b 3: 2b2b 4: 2b1b 5: 3b2b
    floor_plan_area INT,
    PRIMARY KEY(apartment_id, floor_plan_id),
    FOREIGN KEY(apartment_id) REFERENCES apartment (apartment_id)
);

CREATE TABLE IF NOT EXISTS price_plan (
    price_plan_id INTEGER PRIMARY KEY,
    price INT NOT NULL,
    leasing_period INT NOT NULL -- in months, e.g. 12 means 12 months
);

-- many to many relation
CREATE TABLE IF NOT EXISTS floor_plan_price (
    apartment_id INT NOT NULL,
    floor_plan_id INT NOT NULL,
    price_plan_id INT NOT NULL,
    PRIMARY KEY(apartment_id, floor_plan_id, price_plan_id),
    FOREIGN KEY(apartment_id) REFERENCES apartment (apartment_id),
    FOREIGN KEY(floor_plan_id) REFERENCES floor_plan (floor_plan_id),
    FOREIGN KEY(price_plan_id) REFERENCES price_plan (price_plan_id)
);

CREATE TABLE IF NOT EXISTS restaurant (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(30) NOT NULL,
    cuisine_type INT, -- 1: American 2: Chinese 3: Indian 4: Japanese 5: General Asian 6: Vegan 7: Italian 8: Greek
    plaza_id INT,
    address TEXT NOT NULL,
    city VARCHAR(20) NOT NULL,
    state INT NOT NULL, -- only accepts FIPS code of the state, reference: https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
    zipcode CHAR(5) NOT NULL,
    latitude VARCHAR(20),
    longitude VARCHAR(20),
    FOREIGN KEY(plaza_id) REFERENCES plaza (plaza_id)
);

CREATE TABLE IF NOT EXISTS plaza (
    plaza_id INT PRIMARY KEY,
    plaza_name VARCHAR(30) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(20) NOT NULL,
    state INT NOT NULL, -- only accepts FIPS code of the state, reference: https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
    zipcode CHAR(5) NOT NULL,
    latitude VARCHAR(20),
    longitude VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS grocery (
    grocery_id INTEGER PRIMARY KEY,
    grocery_name VARCHAR(30) NOT NULL,
    plaza_id INT,
    address TEXT NOT NULL,
    city VARCHAR(20) NOT NULL,
    state INT NOT NULL, -- only accepts FIPS code of the state, reference: https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
    zipcode CHAR(5) NOT NULL,
    latitude VARCHAR(20),
    longitude VARCHAR(20),
    FOREIGN KEY(plaza_id) REFERENCES plaza (plaza_id)
);

CREATE TABLE IF NOT EXISTS park (
    park_id INT PRIMARY KEY,
    park_name VARCHAR(30) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(20) NOT NULL,
    state INT NOT NULL, -- only accepts FIPS code of the state, reference: https://www.bls.gov/respondents/mwr/electronic-data-interchange/appendix-d-usps-state-abbreviations-and-fips-codes.htm
    zipcode CHAR(5) NOT NULL,
    latitude VARCHAR(20),
    longitude VARCHAR(20)
);
