-- MySQL Workbench Forward Engineering
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Telecel
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Telecel
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Telecel` DEFAULT CHARACTER SET utf8 ;
USE `Telecel` ;

-- -----------------------------------------------------
-- Table `Telecel`.`Customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`Customer` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`Customer` (
  `Customer_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Customer_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`Plans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`Plans` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`Plans` (
  `plan_id` INT NOT NULL AUTO_INCREMENT,
  `plan_name` VARCHAR(20) NOT NULL,
  `data_limit` INT NOT NULL,
  `sms_limit` INT NOT NULL,
  `call_minutes` INT NOT NULL,
  `price` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`plan_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`Subscription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`Subscription` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`Subscription` (
  `subscription_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `phone_number` VARCHAR(13) NOT NULL,
  `plan_id` INT NOT NULL,
  `activation_date` DATE NOT NULL,
  `end_date` DATE,
  PRIMARY KEY (`subscription_id`),
  UNIQUE INDEX `phone_number_UNIQUE` (`phone_number` ASC) VISIBLE,
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `plan_id_idx` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Telecel`.`Customer` (`Customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `plan_id`
    FOREIGN KEY (`plan_id`)
    REFERENCES `Telecel`.`Plans` (`plan_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`CallRecord`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`CallRecord` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`CallRecord` (
  `call_id` INT NOT NULL AUTO_INCREMENT,
  `subscription_id` INT NOT NULL,
  `call_time` DATETIME,
  `duration` INT NOT NULL,
  `destination_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`call_id`),
  INDEX `subscription_id_idx` (`subscription_id` ASC) VISIBLE,
  CONSTRAINT `fk_call_subscription`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `Telecel`.`Subscription` (`subscription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`SMSRecord`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`SMSRecord` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`SMSRecord` (
  `sms_id` INT NOT NULL AUTO_INCREMENT,
  `subscription_id` INT NOT NULL,
  `sms_time` DATETIME NOT NULL,
  `recipient_number` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`sms_id`),
  INDEX `subscription_id_idx` (`subscription_id` ASC) VISIBLE,
  CONSTRAINT `fk_SMS_subscription`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `Telecel`.`Subscription` (`subscription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`DataUsage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`DataUsage` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`DataUsage` (
  `session_id` INT NOT NULL AUTO_INCREMENT,
  `subscription_id` INT NOT NULL,
  `session_start` DATETIME NOT NULL,
  `session_end` DATETIME NOT NULL,
  `MB_used` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`session_id`),
  INDEX `subscription_id_idx` (`subscription_id` ASC) VISIBLE,
  CONSTRAINT `fk_data_subscription`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `Telecel`.`Subscription` (`subscription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`Bill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`Bill` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`Bill` (
  `bill_id` INT NOT NULL AUTO_INCREMENT,
  `subscription_id` INT NOT NULL,
  `billing_period` DATE NOT NULL,
  `amount_due` DECIMAL(7,2) NOT NULL,
  `bill_status` ENUM('Paid', 'Unpaid') NOT NULL,
  `issue_date` DATE NOT NULL,
  `due_date` DATE NOT NULL,
  PRIMARY KEY (`bill_id`),
  INDEX `subscription_id_idx` (`subscription_id` ASC) VISIBLE,
  CONSTRAINT `fk_bill_subscription`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `Telecel`.`Subscription` (`subscription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Telecel`.`CustomerSupport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Telecel`.`CustomerSupport` ;

CREATE TABLE IF NOT EXISTS `Telecel`.`CustomerSupport` (
  `ticket_id` INT NOT NULL AUTO_INCREMENT,
  `subscription_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `ticket_date` DATETIME NOT NULL,
  `complaint_type` ENUM('Billing', 'Plan Change', 'Network Problem') NOT NULL,
  `complaint_description` VARCHAR(200) NULL,
  `complaint_status` ENUM('Open', 'In Progress', 'Resolved') NOT NULL,
  `resolution_date` DATETIME NULL,
  PRIMARY KEY (`ticket_id`),
  INDEX `subscription_id_idx` (`subscription_id` ASC) VISIBLE,
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_support_subscription`
    FOREIGN KEY (`subscription_id`)
    REFERENCES `Telecel`.`Subscription` (`subscription_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_support_customer`
    FOREIGN KEY (`customer_id`)
        REFERENCES `Telecel`.`Customer` (`Customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Modifying e-mail column to have an '@' sign constraint
ALTER TABLE Customer
MODIFY COLUMN email VARCHAR(100) NOT NULL,
ADD CHECK (email LIKE '%@%');

-- Inserting records into the customer table

INSERT INTO Customer (first_name, last_name, address, city, email) VALUES
('Kwame', 'Mensah', '12 Nii Armah St, East Legon', 'Accra', 'kwame.mensah@gmail.com'),
('Akosua', 'Boateng', '21 Osu Badu Crescent, Dzorwulu', 'Accra', 'akosua.boateng@yahoo.com'),
('Yaw', 'Owusu', '7 Liberation Road, Adum', 'Kumasi', 'yaw.owusu@icloud.com'),
('Abena', 'Asare', '3 Asafo Link, Bantama', 'Kumasi', 'abena.asare@gmail.com'),
('Kojo', 'Darko', '44 Cape Coast Road, UCC Campus', 'Cape Coast', 'kojo.darko@yahoo.com'),
('Afia', 'Bonsu', '16 High Street, Sunyani', 'Sunyani', 'afia.bonsu@icloud.com'),
('Kofi', 'Tetteh', '19 Ring Road Central, Asylum Down', 'Accra', 'kofi.tetteh@gmail.com'),
('Ama', 'Antwi', '55 Stadium Road, Ho', 'Ho', 'ama.antwi@yahoo.com'),
('Kwabena', 'Yeboah', '23 Ridge Road, Takoradi', 'Takoradi', 'kwabena.yeboah@icloud.com'),
('Adwoa', 'Addo', '88 Palace St, Tech Junction', 'Kumasi', 'adwoa.addo@gmail.com'),
('Nana', 'Sarpong', '11 Axim Road, Sekondi', 'Sekondi', 'nana.sarpong@yahoo.com'),
('Esi', 'Danquah', '5 Winneba Junction, Central Market', 'Winneba', 'esi.danquah@icloud.com'),
('Yaw', 'Amoako', '27 Legon Ave, Madina', 'Accra', 'yaw.amoako@gmail.com'),
('Akua', 'Ampofo', '9 Airport Hills, Spintex', 'Accra', 'akua.ampofo@yahoo.com'),
('Kwesi', 'Osei', '32 Nungua Barrier, Teshie-Nungua', 'Accra', 'kwesi.osei@icloud.com'),
('Afua', 'Sarfo', '10 Market Street, Tafo', 'Kumasi', 'afua.sarfo@gmail.com'),
('Kojo', 'Dapaah', '22 Roman Ridge, Airport', 'Accra', 'kojo.dapaah@yahoo.com'),
('Ama', 'Nkrumah', '6 Ridge Area, Tamale', 'Tamale', 'ama.nkrumah@icloud.com'),
('Yaw', 'Badu', '14 Community 25, Tema', 'Tema', 'yaw.badu@gmail.com'),
('Akosua', 'Frimpong', '1 Santasi Road, Tech', 'Kumasi', 'akosua.frimpong@yahoo.com');

-- Insert into Plans
INSERT INTO Plans (plan_name, data_limit, sms_limit, call_minutes, price) VALUES
('Basic', 2000, 100, 300, 20.00),
('Standard', 5000, 500, 1000, 45.00),
('Premium', 20000, 2000, 5000, 100.00);

-- Insert into Subscription Table
INSERT INTO Subscription (customer_id, phone_number, plan_id, activation_date, end_date) VALUES
(1, '+233201112233', 2, '2024-10-01', NULL),
(2, '+233541234567', 1, '2024-10-02', NULL),
(3, '+233555678901', 3, '2024-10-02', NULL),
(4, '+233509876543', 2, '2024-10-03', NULL),
(5, '+233201998877', 1, '2024-10-04', NULL),
(6, '+233242345678', 2, '2024-10-05', NULL),
(7, '+233553344556', 3, '2024-10-06', NULL),
(8, '+233203030303', 1, '2024-10-07', NULL),
(9, '+233542456789', 2, '2024-10-08', NULL),
(10, '+233208080808', 2, '2024-10-09', NULL),
(11, '+233209911223', 2, '2024-10-10', NULL),
(12, '+233545512348', 1, '2024-10-11', NULL),
(13, '+233207654321', 3, '2024-10-12', NULL),
(14, '+233553210987', 2, '2024-10-12', NULL),
(15, '+233242467890', 3, '2024-10-13', NULL),
(16, '+233209988776', 1, '2024-10-13', NULL),
(17, '+233552234567', 2, '2024-10-14', NULL),
(18, '+233501234789', 3, '2024-10-14', NULL),
(19, '+233205678912', 1, '2024-10-15', NULL),
(20, '+233243321678', 2, '2024-10-15', NULL);

-- Inseert into call record
INSERT INTO CallRecord (subscription_id, call_time, duration, destination_number) VALUES
(1, '2024-10-01 08:00:00', 180, '+233501122334'),
(1, '2024-10-01 14:45:00', 60, '+233200000111'),
(2, '2024-10-02 09:00:00', 90, '+233552233445'),
(3, '2024-10-03 11:30:00', 300, '+233241234567'),
(4, '2024-10-04 07:15:00', 120, '+233201201201'),
(4, '2024-10-04 17:00:00', 200, '+233201202202'),
(5, '2024-10-05 12:00:00', 150, '+233203303303'),
(6, '2024-10-06 13:00:00', 75, '+233507070707'),
(7, '2024-10-07 14:20:00', 240, '+233244000111'),
(8, '2024-10-08 08:40:00', 60, '+233277788899'),
(9, '2024-10-09 15:15:00', 180, '+233208888888'),
(10, '2024-10-10 10:00:00', 90, '+233255667788'),
(11, '2024-10-11 07:30:00', 120, '+233200123456'),
(12, '2024-10-12 11:00:00', 300, '+233209876543'),
(13, '2024-10-13 09:00:00', 100, '+233245612345'),
(13, '2024-10-13 13:20:00', 250, '+233245678901'),
(14, '2024-10-14 16:00:00', 180, '+233500123123'),
(15, '2024-10-15 18:30:00', 75, '+233509988776'),
(16, '2024-10-16 12:45:00', 300, '+233200200200'),
(17, '2024-10-17 19:30:00', 90, '+233243345678'),
(18, '2024-10-18 20:00:00', 110, '+233554433221'),
(18, '2024-10-18 21:00:00', 180, '+233543212345'),
(19, '2024-10-19 13:10:00', 240, '+233277009900'),
(20, '2024-10-20 15:00:00', 120, '+233208800111'),
(20, '2024-10-20 18:00:00', 60, '+233208800222'),
(2, '2024-10-02 20:15:00', 45, '+233205555555'),
(3, '2024-10-03 21:00:00', 90, '+233504040404'),
(7, '2024-10-07 10:30:00', 210, '+233203040506'),
(10, '2024-10-10 09:20:00', 100, '+233209900998'),
(14, '2024-10-14 13:45:00', 140, '+233241231234');

-- Insert into SMS RECORD

INSERT INTO SMSRecord (subscription_id, sms_time, recipient_number) VALUES
(1, '2024-10-01 08:10:00', '+233501122334'),
(1, '2024-10-01 14:50:00', '+233555555111'),
(2, '2024-10-02 09:05:00', '+233552233445'),
(3, '2024-10-03 11:35:00', '+233241234567'),
(4, '2024-10-04 07:20:00', '+233201201201'),
(5, '2024-10-05 12:05:00', '+233203303303'),
(6, '2024-10-06 13:05:00', '+233507070707'),
(7, '2024-10-07 14:25:00', '+233244000111'),
(8, '2024-10-08 08:45:00', '+233277788899'),
(9, '2024-10-09 15:20:00', '+233208888888'),
(10, '2024-10-10 10:05:00', '+233255667788'),
(11, '2024-10-11 07:35:00', '+233200123456'),
(12, '2024-10-12 11:05:00', '+233209876543'),
(13, '2024-10-13 09:05:00', '+233245612345'),
(13, '2024-10-13 13:25:00', '+233245678901'),
(14, '2024-10-14 16:05:00', '+233500123123'),
(15, '2024-10-15 18:35:00', '+233509988776'),
(16, '2024-10-16 12:50:00', '+233200200200'),
(17, '2024-10-17 19:35:00', '+233243345678'),
(18, '2024-10-18 20:05:00', '+233554433221'),
(19, '2024-10-19 13:15:00', '+233277009900'),
(20, '2024-10-20 15:05:00', '+233208800111'),
(3, '2024-10-03 21:05:00', '+233504040404'),
(7, '2024-10-07 10:35:00', '+233203040506'),
(10, '2024-10-10 09:25:00', '+233209900998'),
(2, '2024-10-02 20:20:00', '+233205555555'),
(8, '2024-10-08 09:00:00', '+233276543210'),
(14, '2024-10-14 13:50:00', '+233241231234'),
(5, '2024-10-05 18:00:00', '+233277100200');

-- Insert into data usage

INSERT INTO DataUsage (subscription_id, session_start, session_end, mb_used) VALUES
(1, '2024-10-01 06:00:00', '2024-10-01 06:30:00', 120.5),
(2, '2024-10-02 08:00:00', '2024-10-02 08:45:00', 300.0),
(3, '2024-10-03 07:00:00', '2024-10-03 07:30:00', 200.25),
(4, '2024-10-04 06:30:00', '2024-10-04 07:00:00', 180.75),
(5, '2024-10-05 10:00:00', '2024-10-05 10:20:00', 160.0),
(6, '2024-10-06 09:00:00', '2024-10-06 09:25:00', 150.75),
(7, '2024-10-07 11:00:00', '2024-10-07 11:30:00', 140.5),
(8, '2024-10-08 12:00:00', '2024-10-08 12:30:00', 130.25),
(9, '2024-10-09 13:00:00', '2024-10-09 13:40:00', 210.0),
(10, '2024-10-10 14:00:00', '2024-10-10 14:30:00', 250.0),
(11, '2024-10-11 08:00:00', '2024-10-11 08:20:00', 180.0),
(12, '2024-10-12 09:00:00', '2024-10-12 09:30:00', 190.0),
(13, '2024-10-13 10:00:00', '2024-10-13 10:40:00', 300.0),
(14, '2024-10-14 11:00:00', '2024-10-14 11:45:00', 280.0),
(15, '2024-10-15 12:00:00', '2024-10-15 12:30:00', 260.5),
(16, '2024-10-16 13:00:00', '2024-10-16 13:20:00', 240.0),
(17, '2024-10-17 14:00:00', '2024-10-17 14:25:00', 220.25),
(18, '2024-10-18 15:00:00', '2024-10-18 15:30:00', 200.0),
(19, '2024-10-19 16:00:00', '2024-10-19 16:30:00', 190.5),
(20, '2024-10-20 17:00:00', '2024-10-20 17:30:00', 175.75),
(1, '2024-10-01 19:00:00', '2024-10-01 19:20:00', 60.0),
(2, '2024-10-02 20:00:00', '2024-10-02 20:30:00', 70.0),
(3, '2024-10-03 21:00:00', '2024-10-03 21:25:00', 80.5),
(4, '2024-10-04 22:00:00', '2024-10-04 22:30:00', 90.0),
(5, '2024-10-05 23:00:00', '2024-10-05 23:15:00', 100.0),
(6, '2024-10-06 07:00:00', '2024-10-06 07:30:00', 110.25),
(7, '2024-10-07 06:00:00', '2024-10-07 06:45:00', 130.0),
(8, '2024-10-08 05:00:00', '2024-10-08 05:30:00', 140.0),
(9, '2024-10-09 04:00:00', '2024-10-09 04:15:00', 155.0),
(10, '2024-10-10 03:00:00', '2024-10-10 03:20:00', 160.5);

-- Insert into Bill Table 
INSERT INTO Bill (subscription_id, billing_period, amount_due, bill_status, issue_date, due_date) VALUES
(1, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(2, '2024-10-31', 20.00, 'Paid', '2024-11-01', '2024-11-15'),
(3, '2024-10-31', 90.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(4, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(5, '2024-10-31', 20.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(6, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(7, '2024-10-31', 90.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(8, '2024-10-31', 20.00, 'Paid', '2024-11-01', '2024-11-15'),
(9, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(10, '2024-10-31', 45.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(11, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(12, '2024-10-31', 20.00, 'Paid', '2024-11-01', '2024-11-15'),
(13, '2024-10-31', 90.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(14, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(15, '2024-10-31', 90.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(16, '2024-10-31', 20.00, 'Paid', '2024-11-01', '2024-11-15'),
(17, '2024-10-31', 45.00, 'Paid', '2024-11-01', '2024-11-15'),
(18, '2024-10-31', 90.00, 'Unpaid', '2024-11-01', '2024-11-15'),
(19, '2024-10-31', 20.00, 'Paid', '2024-11-01', '2024-11-15'),
(20, '2024-10-31', 45.00, 'Unpaid', '2024-11-01', '2024-11-15');

-- Insert into Customer support
INSERT INTO CustomerSupport (customer_id, subscription_id, ticket_date, complaint_type, complaint_description, complaint_status, resolution_date) VALUES
(1, 1, '2024-10-01 09:00:00', 'Billing', 'Charged twice for October bill.', 'Resolved', '2024-10-02 11:30:00'),
(2, 2, '2024-10-03 14:15:00', 'Network Problem', 'No signal in Madina area.', 'In Progress', NULL),
(3, 3, '2024-10-05 08:45:00', 'Plan Change', 'Requested upgrade to Unlimited plan.', 'Resolved', '2024-10-06 10:00:00'),
(4, 4, '2024-10-07 16:10:00', 'Network Problem', 'Frequent call drops in Kumasi.', 'Open', NULL),
(5, 5, '2024-10-08 10:20:00', 'Billing', 'Late fee added incorrectly.', 'Resolved', '2024-10-09 09:15:00'),
(6, 6, '2024-10-09 11:00:00', 'Plan Change', 'Request to switch to Standard plan.', 'In Progress', NULL),
(7, 7, '2024-10-10 15:30:00', 'Network Problem', 'Data very slow during evening.', 'Open', NULL),
(8, 8, '2024-10-11 07:50:00', 'Billing', 'Refund not reflected.', 'Resolved', '2024-10-12 13:45:00'),
(9, 9, '2024-10-12 18:00:00', 'Network Problem', 'Can’t make calls after 6pm.', 'In Progress', NULL),
(10, 10, '2024-10-13 09:30:00', 'Plan Change', 'Add more SMS to current plan.', 'Resolved', '2024-10-14 11:00:00');

-- Advanced Queries for Business Analytics


-- Retrieving customer information and subscribed phone number using the JOIN Statement

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_name, c.address, c.city, c.email,
    s.phone_number
FROM
    Customer c
        JOIN
    Subscription s ON c.customer_id = s.customer_id
    WHERE s.end_date IS NULL
ORDER BY c.customer_id ASC;

-- Total Data(MB) used by each customer in the month of October 2024
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_name, 
    s.phone_number,
    SUM(MB_used) AS total_mb_exhausted
FROM
    Customer c
        JOIN
    Subscription s ON c.customer_id = s.customer_id
        JOIN
    DataUsage d ON s.subscription_id = d.subscription_id
WHERE
    MONTH(d.session_start) = 10
        AND YEAR(session_start) = 2024
GROUP BY s.subscription_id;    

-- Retrieving customers with overdue bills for the current month (October 2024)

SELECT 
	b.bill_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Full_name, 
    s.phone_number, b.amount_due
FROM
    Customer c
        JOIN
    Subscription s ON c.customer_id = s.customer_id
        JOIN
    Bill b ON s.subscription_id = b.subscription_id
WHERE
	b.bill_status = 'Unpaid'
    AND MONTH(b.billing_period) = 10
        AND YEAR(b.billing_period) = 2024
         
;

-- Create view for customer information icludinng city/location and phone number and name of current plan
CREATE VIEW view_customer_data AS 
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_name, c.city, c.email,
    s.phone_number, p.plan_name AS Current_Plan
FROM
    Customer c
        JOIN
    Subscription s ON c.customer_id = s.customer_id
        JOIN
    Plans p ON s.plan_id = p.plan_id
ORDER BY City ASC;

SELECT * FROM Telecel.view_customer_data;


-- Finding customers with low call usage

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS Full_name,
    SUM(cr.duration) / 60 AS total_call_minutes
FROM
    Customer c
        JOIN
    Subscription s ON c.customer_id = s.customer_id
        JOIN
    CallRecord cr ON s.subscription_id = cr.subscription_id
GROUP BY Full_name
HAVING SUM(cr.duration) < 300; -- 300 seconds is equivalent to 5 minutes

-- Using a stored procedure to generate automated monthly bills for customers 
DELIMITER $$

CREATE PROCEDURE automated_monthly_billing_2024()
BEGIN
  INSERT INTO Bill (subscription_id, billing_period, amount_due, bill_status, issue_date, due_date)
  SELECT 
    s.subscription_id,
    '2024-11-30',
    p.price,
    'Unpaid',
    '2024-11-15',
    DATE_ADD('2024-11-15', INTERVAL 30 DAY)
  FROM Subscription s
  JOIN Plans p ON s.plan_id = p.plan_id ;
END $$

DELIMITER ;

call Telecel.automated_monthly_billing_2024();

