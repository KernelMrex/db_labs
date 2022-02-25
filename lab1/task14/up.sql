CREATE DATABASE IF NOT EXISTS `task14`;

USE `task14`;

CREATE TABLE IF NOT EXISTS `coach` (
    `coach_id` INT NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `middle_name` VARCHAR(255),
    `last_name` VARCHAR(255) NOT NULL,
    `qualification` TINYINT NOT NULL,
    `birth_date` DATE NOT NULL,
    PRIMARY KEY (`coach_id`)
);

CREATE TABLE IF NOT EXISTS `student` (
    `student_id` INT NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `middle_name` VARCHAR(255),
    `last_name` VARCHAR(255) NOT NULL,
    `birth_date` DATE NOT NULL,
    `coach_id` INT NOT NULL,
    PRIMARY KEY (`student_id`),
    FOREIGN KEY (`coach_id`) REFERENCES `coach`(`coach_id`)
);

CREATE TABLE IF NOT EXISTS `standart` (
    `standart_id` INT NOT NULL,
    `name` VARCHAR(255),
    `description` TEXT NOT NULL,
    `sex` TINYINT NOT NULL,
    PRIMARY KEY (`standart_id`)
);

CREATE TABLE IF NOT EXISTS `examinator` (
    `examinator_id` INT NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `middle_name` VARCHAR(255),
    `last_name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`examinator_id`)
);

CREATE TABLE IF NOT EXISTS `result` (
    `result_id` INT NOT NULL,
    `student_id` INT NOT NULL,
    `standart_id` INT NOT NULL,
    `examinator_id` INT NOT NULL,
    `is_passed` TINYINT NOT NULL,
    `passed_at` DATETIME NOT NULL,
    PRIMARY KEY (`result_id`),
    FOREIGN KEY (`student_id`) REFERENCES `student`(`student_id`),
    FOREIGN KEY (`standart_id`) REFERENCES `standart`(`standart_id`),
    FOREIGN KEY (`examinator_id`) REFERENCES `examinator`(`examinator_id`)
);
