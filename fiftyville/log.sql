-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Get all interviews
SELECT * FROM interviews WHERE month = 7 AND day = 28 AND year = 2023;

-- Get phone calls from date of theft
SELECT * FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60;

-- Get names of callers from the above phone calls
SELECT name FROM people WHERE phone_number IN
(
    SELECT caller FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60
);

-- Get names of receivers from the above phone calls
SELECT name FROM people WHERE phone_number IN
(
    SELECT receiver FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60
);

-- Get flights from Fiftyville for July 29 ordered by departure time
SELECT id, hour, minute FROM flights WHERE origin_airport_id IN
(
    SELECT id FROM airports WHERE city = 'Fiftyville'
)
AND month = 7
AND day = 29
ORDER BY hour, minute;

-- Find passengers on the earliest flight
SELECT name FROM people WHERE passport_number IN
(
    SELECT passport_number FROM passengers WHERE flight_id = 36
);

-- Find intersection of passengers on that flight that made a less than one minute phone call on the day of the theft.
SELECT name FROM people WHERE passport_number IN
(
    SELECT passport_number FROM passengers WHERE flight_id = 36
)
INTERSECT
SELECT name FROM people WHERE phone_number IN
(
    SELECT caller FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60
);

-- Find the place thief escaped to
SELECT city FROM airports WHERE id =
(
    SELECT destination_airport_id FROM flights WHERE id = 36
);

-- Get license plates exiting the bakery within 30 minutes of the theft
SELECT license_plate FROM bakery_security_logs WHERE month = 7 AND day = 28 AND year = 2023 AND hour = 10 AND minute BETWEEN 15 AND 45;

-- Get names of people whose license plates match those from the previous query
SELECT name FROM people WHERE license_plate IN
(
    SELECT license_plate FROM bakery_security_logs WHERE month = 7 AND day = 28 AND year = 2023 AND hour = 10 AND minute BETWEEN 15 AND 45
);

-- Intersect license plate owners with passengers on flight
SELECT name FROM people WHERE license_plate IN
(
    SELECT license_plate FROM bakery_security_logs WHERE month = 7 AND day = 28 AND year = 2023 AND hour = 10 AND minute BETWEEN 15 AND 45
)
INTERSECT
SELECT name FROM people WHERE passport_number IN
(
    SELECT passport_number FROM passengers WHERE flight_id = 36
)
INTERSECT
SELECT name FROM people WHERE phone_number IN
(
    SELECT caller FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60
);

-- Get names of people who performed a transaction at the atm the morning of the robbery
SELECT name FROM people WHERE id IN
(
    SELECT person_id FROM bank_accounts WHERE account_number IN
    (
        SELECT account_number FROM atm_transactions WHERE atm_location = 'Leggett Street' AND month = 7 AND day = 28 AND year = 2023 AND transaction_type = 'withdraw'
    )
);

-- Add atm people to intersect query
SELECT name FROM people WHERE license_plate IN
(
    SELECT license_plate FROM bakery_security_logs WHERE month = 7 AND day = 28 AND year = 2023 AND hour = 10 AND minute BETWEEN 15 AND 25
)
INTERSECT
SELECT name FROM people WHERE passport_number IN
(
    SELECT passport_number FROM passengers WHERE flight_id = 36
)
INTERSECT
SELECT name FROM people WHERE phone_number IN
(
    SELECT caller FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60
)
INTERSECT
SELECT name FROM people WHERE id IN
(
    SELECT person_id FROM bank_accounts WHERE account_number IN
    (
        SELECT account_number FROM atm_transactions WHERE atm_location = 'Leggett Street' AND month = 7 AND day = 28 AND year = 2023 AND transaction_type = 'withdraw'
    )
);

--Thief is Bruce. Find reciever of Bruce's call to find accomplice
SELECT name FROM people WHERE phone_number IN
(
    SELECT receiver FROM phone_calls WHERE month = 7 AND day = 28 AND year = 2023 AND duration <= 60 AND caller IN
    (
        SELECT phone_number FROM people WHERE name = 'Bruce'
    )
);
