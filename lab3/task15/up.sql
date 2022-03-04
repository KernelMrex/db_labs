CREATE DATABASE IF NOT EXISTS `task15`;

USE `task15`;

CREATE TABLE IF NOT EXISTS `transport_node` (
    `transport_node_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `location` VARCHAR(255) NOT NULL,
    `type` TINYINT NOT NULL DEFAULT 1,
    PRIMARY KEY (`transport_node_id`)
);

CREATE TABLE IF NOT EXISTS `route` (
    `route_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `starting_node_id` INT NOT NULL,
    `destination_node_id` INT NOT NULL,
    `qualification` TINYINT NOT NULL,
    `birth_date` DATE NOT NULL,
    PRIMARY KEY (`route_id`),
    FOREIGN KEY (`starting_node_id`) REFERENCES `transport_node`(`transport_node_id`),
    FOREIGN KEY (`destination_node_id`) REFERENCES `transport_node`(`transport_node_id`)
);

CREATE TABLE IF NOT EXISTS `passenger` (
    `passenger_id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(255) NOT NULL,
    `middle_name` VARCHAR(255),
    `last_name` VARCHAR(255) NOT NULL,
    `document_type` TINYINT NOT NULL,
    `document_number` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`passenger_id`)
);

CREATE TABLE IF NOT EXISTS `transport` (
    `transport_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `type` TINYINT NOT NULL DEFAULT 1,
    `current_route_id` INT,
    `status` TINYINT,
    PRIMARY KEY (`transport_id`),
    FOREIGN KEY (`current_route_id`) REFERENCES `route`(`route_id`)
);

CREATE TABLE IF NOT EXISTS `ticket` (
    `ticket_id` INT NOT NULL AUTO_INCREMENT,
    `price` INT NOT NULL,
    `currency` CHAR(3) NOT NULL,
    `passenger_id` INT NOT NULL,
    `route_id` INT NOT NULL,
    `transport_id` INT NOT NULL,
    `datetime_at` DATETIME NOT NULL,
    PRIMARY KEY (`ticket_id`)
);