CREATE DATABASE traffic_management_db;
USE traffic_management_db;


CREATE TABLE vehicle (
reg_no VARCHAR(15) PRIMARY KEY,
model VARCHAR(50),
vehicle_type VARCHAR(20),
owner_name VARCHAR(100)
);


CREATE TABLE driver (
license_no VARCHAR(20) PRIMARY KEY,
driver_name VARCHAR(100),
contact VARCHAR(10),
address VARCHAR(255)
);


CREATE TABLE accident (
    accident_id INT PRIMARY KEY AUTO_INCREMENT,
    accident_date DATE,
    location VARCHAR(100),
    severity VARCHAR(20)
);


CREATE TABLE accident_participation (
    accident_id INT,
    reg_no VARCHAR(15),
    license_no VARCHAR(20),
    damage_amount DECIMAL(10, 2),
    FOREIGN KEY (accident_id) REFERENCES accident(accident_id),
    FOREIGN KEY (reg_no) REFERENCES vehicle(reg_no),
    FOREIGN KEY (license_no) REFERENCES driver(license_no)
);

CREATE TABLE violation (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    reg_no VARCHAR(15),      
    license_no VARCHAR(20),  
    violation_type VARCHAR(50),
    fine_amount DECIMAL(10, 2),
    violation_date DATE,
    payment_status VARCHAR(20) DEFAULT 'Unpaid', 
    FOREIGN KEY (reg_no) REFERENCES vehicle(reg_no),
    FOREIGN KEY (license_no) REFERENCES driver(license_no)
);



INSERT INTO vehicle 
VALUES
('KA-01-1234', 'Tesla Model 3', 'Car', 'Rahul Sharma'),
('DL-02-5678', 'Honda Activa', 'Bike', 'Anita Verma');



INSERT INTO driver
VALUES
('DL123456789', 'Rahul Sharma', '9876543210', 'Indiranagar, Bangalore'),
('DL987654321', 'Suresh Kumar', '9988776655', 'Rohini, Delhi');


INSERT INTO accident (accident_date, location, severity) 
VALUES ('2023-10-15', 'Silk Board, Bangalore', 'Minor'),
('2023-11-20', 'Connaught Place, Delhi', 'Major');


INSERT INTO accident_participation 
VALUES
(1, 'KA-01-1234', 'DL123456789', 5000.00),
(2, 'DL-02-5678', 'DL987654321', 15000.00);


INSERT INTO violation (reg_no, license_no, violation_type, fine_amount, violation_date, payment_status)
VALUES 
('KA-01-1234', 'DL123456789', 'Over Speeding', 2000.00, '2024-03-01', 'Paid'),
('DL-02-5678', 'DL987654321', 'Red Light Jumping', 1000.00, '2024-03-05', 'Unpaid'),
('KA-01-1234', 'DL123456789', 'No Helmet', 1000.00, '2024-03-10', 'Unpaid'),
('DL-02-5678', 'DL987654321', 'Drunk Driving', 10000.00, '2024-03-12', 'Paid'),
('KA-01-1234', 'DL123456789', 'Wrong Way Driving', 500.00, '2024-03-15', 'Unpaid'),
('DL-02-5678', 'DL987654321', 'Using Mobile Phone', 5000.00, '2024-03-18', 'Unpaid'),
('KA-01-1234', 'DL123456789', 'Triple Riding', 1000.00, '2024-03-20', 'Paid'),
('DL-02-5678', 'DL987654321', 'No Parking', 500.00, '2024-03-22', 'Unpaid');

select * from accident;

select * from accident_participation;

select * from driver;

select * from vehicle;

select * from violation;



-- 1. Find all vehicles involved in 'Major' accidents

SELECT v.reg_no, v.model, a.location 
FROM vehicle v
JOIN accident_participation ap 
ON v.reg_no = ap.reg_no
JOIN accident a 
ON ap.accident_id = a.accident_id
WHERE a.severity = 'Major';

-- Output: DL-02-5678 (Honda Activa), Connaught Place
-- Insight: Only one vehicle is involved in a major accident, so this case is more serious.


-- 2. Total damage amount recorded in the system

SELECT SUM(damage_amount) as total_damage 
FROM accident_participation;

-- Output: 20000
-- Insight: Total accident damage is ₹20,000, showing overall financial impact.


-- 3. Find total unpaid fines for Rahul Sharma

SELECT d.driver_name, SUM(v.fine_amount) as total_due
FROM driver d
JOIN violation v ON d.license_no = v.license_no
WHERE v.payment_status = 'Unpaid' AND d.driver_name = 'Rahul Sharma'
GROUP BY d.driver_name;

-- Output: 1500
-- Insight: Rahul still has ₹1500 unpaid fines, so not all violations are cleared.


-- 4. Vehicles with more than 3 violations

SELECT reg_no, COUNT(*) as violation_count
FROM violation
GROUP BY reg_no
HAVING COUNT(*) > 3;

-- Output: KA-01-1234, DL-02-5678
-- Insight: Both vehicles are repeat offenders and risky on road.


-- 5. Drivers involved in accidents

SELECT d.driver_name
FROM driver d
JOIN accident_participation ap
ON d.license_no = ap.license_no;

-- Output: Rahul Sharma, Suresh Kumar
-- Insight: Both drivers have been involved in accidents.


-- 6. Total number of accidents

SELECT COUNT(*) AS total_accidents
FROM accident;

-- Output: 2
-- Insight: Only 2 accidents recorded, dataset is small.


-- 7. Accidents with damage > 10,000

SELECT a.accident_id, a.location, ap.damage_amount
FROM accident a
JOIN accident_participation ap
ON a.accident_id = ap.accident_id
WHERE ap.damage_amount > 10000;

-- Output: Accident 2, ₹15000
-- Insight: One accident caused high damage, so it's severe.


-- 8. List all unpaid violations

SELECT *
FROM violation
WHERE payment_status = 'Unpaid';

-- Output: 5 rows
-- Insight: Many fines are still unpaid, showing poor compliance.


-- 9. Total fine collected (Paid only)

SELECT SUM(fine_amount) AS total_collected
FROM violation
WHERE payment_status = 'Paid';

-- Output: 13000
-- Insight: ₹13,000 has been collected as fines so far.


-- 10. Driver with highest total fines

SELECT d.driver_name, SUM(v.fine_amount) AS total_fine
FROM driver d
JOIN violation v 
ON d.license_no = v.license_no
GROUP BY d.driver_name
ORDER BY total_fine DESC
LIMIT 1; 

-- Output: Suresh Kumar (16500)
-- Insight: Suresh has highest fines, so more violations.


-- 11. Vehicles with no violations

SELECT v.reg_no
FROM vehicle v
LEFT JOIN violation vi
ON v.reg_no = vi.reg_no
WHERE vi.reg_no IS NULL;

-- Output: None
-- Insight: Every vehicle has at least one violation.


-- 12. Violations per driver

SELECT d.driver_name, COUNT(v.violation_id) AS total_violations
FROM driver d
JOIN violation v
ON d.license_no = v.license_no
GROUP BY d.driver_name;

-- Output: Rahul → 4, Suresh → 4
-- Insight: Both drivers have equal number of violations.


-- 13. Most common violation type

SELECT violation_type, COUNT(*) AS count
FROM violation
GROUP BY violation_type
ORDER BY count DESC
LIMIT 1;

-- Output: All = 1
-- Insight: No single violation is repeated more than others.


-- 14. Total damage per driver

SELECT d.driver_name, SUM(ap.damage_amount) AS total_damage
FROM driver d
JOIN accident_participation ap
ON d.license_no = ap.license_no
GROUP BY d.driver_name;

-- Output: Rahul → 5000, Suresh → 15000
-- Insight: Suresh caused more damage, higher risk.


-- 15. Accidents in 2023

SELECT *
FROM accident
WHERE YEAR(accident_date) = 2023;

-- Output: Both accidents
-- Insight: All accidents happened in 2023.


-- 16. Drivers with both accidents and violations

SELECT DISTINCT d.driver_name
FROM driver d
JOIN accident_participation ap
ON d.license_no = ap.license_no
JOIN violation v
ON d.license_no = v.license_no;

-- Output: Rahul Sharma, Suresh Kumar
-- Insight: Both drivers are risky (accidents + violations).


-- 17. Average fine amount

SELECT AVG(fine_amount) AS avg_fine
FROM violation;

-- Output: 2875
-- Insight: Average fine is ₹2875 per violation.


-- 18. Latest violation

SELECT *
FROM violation
ORDER BY violation_date DESC
LIMIT 1;

-- Output: No Parking, ₹500, Unpaid
-- Insight: Latest violation is minor but still unpaid.

-- 19. Rank drivers based on total fines

SELECT d.driver_name,
       SUM(v.fine_amount) AS total_fine,
       RANK() OVER (ORDER BY SUM(v.fine_amount) DESC) AS rank_no
FROM driver d
JOIN violation v
ON d.license_no = v.license_no
GROUP BY d.driver_name;

-- Output: 
-- 1 → Suresh Kumar
-- 2 → Rahul Sharma
-- Insight: Suresh is top offender.



