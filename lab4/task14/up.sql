CREATE DATABASE IF NOT EXISTS `task15`;

USE `task15`;

CREATE TABLE IF NOT EXISTS `prisoner`
(
    `prisoner_id`   INT          NOT NULL AUTO_INCREMENT,
    `name`          VARCHAR(255) NOT NULL,
    `status`        TINYINT      NOT NULL,
    `date_of_birth` DATE         NOT NULL,
    PRIMARY KEY (`prisoner_id`)
);

CREATE TABLE IF NOT EXISTS `criminal`
(
    `criminal_id` INT          NOT NULL AUTO_INCREMENT,
    `code`        INT          NOT NULL,
    `name`        VARCHAR(255) NOT NULL,
    `description` TEXT         NOT NULL,
    PRIMARY KEY (`criminal_id`)
);

CREATE TABLE IF NOT EXISTS `imprisonment`
(
    `imprisonment_id` INT      NOT NULL AUTO_INCREMENT,
    `prisoner_id`     INT      NOT NULL,
    `start_of_term`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `end_of_term`     DATETIME,
    PRIMARY KEY (`imprisonment_id`),
    FOREIGN KEY (`prisoner_id`) REFERENCES `prisoner` (`prisoner_id`)
);

CREATE TABLE IF NOT EXISTS `case`
(
    `case_id`         INT          NOT NULL AUTO_INCREMENT,
    `imprisonment_id` INT,
    `name`            VARCHAR(255) NOT NULL,
    `description`     TEXT,
    PRIMARY KEY (`case_id`),
    FOREIGN KEY (`imprisonment_id`) REFERENCES `imprisonment` (`imprisonment_id`)
);

CREATE TABLE IF NOT EXISTS `criminal_to_case`
(
    `criminal_to_case_id` INT NOT NULL AUTO_INCREMENT,
    `case_id`             INT NOT NULL,
    `criminal_id`         INT NOT NULL,
    PRIMARY KEY (`criminal_to_case_id`),
    FOREIGN KEY (`case_id`) REFERENCES `case` (`case_id`),
    FOREIGN KEY (`criminal_id`) REFERENCES `criminal` (`criminal_id`),
    UNIQUE (`case_id`, `criminal_id`)
);

CREATE TABLE IF NOT EXISTS `evidence`
(
    `evidence_id`   INT      NOT NULL AUTO_INCREMENT,
    `case_id`       INT      NOT NULL,
    `description`   TEXT     NOT NULL,
    `date_of_given` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `victim_name`   VARCHAR(255),
    PRIMARY KEY (`evidence_id`),
    FOREIGN KEY (`case_id`) REFERENCES `case` (`case_id`)
);