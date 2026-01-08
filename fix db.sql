-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE IF NOT EXISTS `sleepy_panda` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sleepy_panda`;

-- Core user table (referenced by many foreign keys)
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `hashed_password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gender` int DEFAULT NULL,
  `work` enum('Accountant','Doctor','Engineer','Lawyer','Manager','Nurse','Sales Representative','Salesperson','Scientist','Software Engineer','Teacher') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `work_id` int DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `age` int DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `height` float DEFAULT NULL,
  `upper_pressure` int DEFAULT NULL,
  `lower_pressure` int DEFAULT NULL,
  `daily_steps` int DEFAULT NULL,
  `heart_rate` int DEFAULT NULL,
  `reset_token` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`),
  KEY `idx_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table sleepy_panda.work_data
CREATE TABLE IF NOT EXISTS `work_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `quality_of_sleep` float DEFAULT NULL,
  `physical_activity_level` float DEFAULT NULL,
  `stress_level` float DEFAULT NULL,
  `work_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_work_data_email` (`email`),
  CONSTRAINT `fk_work_data_user_email` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table sleepy_panda.daily
CREATE TABLE IF NOT EXISTS `daily` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NOT NULL,
  `upper_pressure` int DEFAULT NULL,
  `lower_pressure` int DEFAULT NULL,
  `daily_steps` int DEFAULT NULL,
  `heart_rate` int DEFAULT NULL,
  `duration` float NOT NULL,
  `prediction_result` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_daily_user_id` (`user_id`),
  KEY `idx_daily_email` (`email`),
  CONSTRAINT `fk_daily_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_daily_user_email` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table sleepy_panda.sleep_records
CREATE TABLE IF NOT EXISTS `sleep_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `sleep_time` datetime NOT NULL,
  `wake_time` datetime NOT NULL,
  `duration` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sleep_records_email` (`email`),
  CONSTRAINT `fk_sleep_records_user_email` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table sleepy_panda.monthly_predictions
CREATE TABLE IF NOT EXISTS `monthly_predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `prediction_result` enum('Insomnia','Normal','Sleep Apnea') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_monthly_predictions_email` (`email`),
  CONSTRAINT `fk_monthly_predictions_user_email` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table sleepy_panda.weekly_predictions
CREATE TABLE IF NOT EXISTS `weekly_predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `prediction_result` enum('Insomnia','Normal','Sleep Apnea') NOT NULL,
  `prediction_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_weekly_predictions_email` (`email`),
  CONSTRAINT `fk_weekly_predictions_user_email` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table sleepy_panda.feedback
CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `feedback` text COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_feedback_email` (`email`),
  CONSTRAINT `fk_feedback_user_email` FOREIGN KEY (`email`) REFERENCES `users` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for trigger sleepy_panda.update_or_insert_daily_from_sleep_records
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DELIMITER $$
CREATE TRIGGER `update_or_insert_daily_from_sleep_records`
AFTER INSERT ON `sleep_records`
FOR EACH ROW
BEGIN
  DECLARE sleepDate DATE;
  SET sleepDate = DATE(NEW.sleep_time);

  IF EXISTS (SELECT 1 FROM daily WHERE email = NEW.email AND date = sleepDate) THEN
    UPDATE daily
    SET duration = NEW.duration
    WHERE email = NEW.email AND date = sleepDate;
  ELSE
    INSERT INTO daily (email, date, upper_pressure, lower_pressure, daily_steps, heart_rate, duration)
    VALUES (NEW.email, sleepDate, NULL, NULL, NULL, NULL, NEW.duration);
  END IF;
END$$
DELIMITER ;

SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger sleepy_panda.update_or_insert_daily_from_users
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DELIMITER $$
CREATE TRIGGER `update_or_insert_daily_from_users`
AFTER UPDATE ON `users`
FOR EACH ROW
BEGIN
  DECLARE currentDate DATE;
  SET currentDate = CURDATE();

  UPDATE daily
  SET 
    upper_pressure = IFNULL(NEW.upper_pressure, upper_pressure),
    lower_pressure = IFNULL(NEW.lower_pressure, lower_pressure),
    daily_steps = IFNULL(NEW.daily_steps, daily_steps),
    heart_rate = IFNULL(NEW.heart_rate, heart_rate)
  WHERE email = NEW.email AND date = currentDate;

  IF ROW_COUNT() = 0 THEN
    INSERT INTO daily (email, date, upper_pressure, lower_pressure, daily_steps, heart_rate, duration)
    VALUES (NEW.email, currentDate, NEW.upper_pressure, NEW.lower_pressure, NEW.daily_steps, NEW.heart_rate, 0);
  END IF;
END$$
DELIMITER ;

SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
