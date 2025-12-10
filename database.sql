-- ============================================
-- LMS Database Schema (Clean Version)
-- No user data - only structure
-- ============================================
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!50503 SET NAMES utf8mb4 */
;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */
;
/*!40103 SET TIME_ZONE='+00:00' */
;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;
-- ============================================
-- Table: users
-- ============================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('STUDENT', 'TEACHER', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
  `student_id` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `qualification` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `status` enum('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `course_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_student_id` (`student_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Table: courses
-- ============================================
DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(255) NOT NULL,
  `level` enum('BEGINNER', 'INTERMEDIATE', 'ADVANCED') NOT NULL DEFAULT 'BEGINNER',
  `instructor_id` bigint NOT NULL,
  `duration` varchar(255) NOT NULL,
  `students` int DEFAULT '0',
  `rating` double DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_instructor` (`instructor_id`),
  KEY `idx_category` (`category`),
  KEY `idx_level` (`level`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Table: enrollments
-- ============================================
DROP TABLE IF EXISTS `enrollments`;
CREATE TABLE `enrollments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `completed` bit(1) DEFAULT NULL,
  `enrolled_at` datetime(6) DEFAULT NULL,
  `progress` int DEFAULT NULL,
  `course_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKi0g6mfijtuh199nj653nva6j5` (`student_id`, `course_id`),
  KEY `FKho8mcicp4196ebpltdn9wl6co` (`course_id`),
  CONSTRAINT `FK2lha5vwilci2yi3vu5akusx4a` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKho8mcicp4196ebpltdn9wl6co` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Table: assignments
-- ============================================
DROP TABLE IF EXISTS `assignments`;
CREATE TABLE `assignments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `due_date` datetime(6) NOT NULL,
  `max_points` int DEFAULT NULL,
  `course_id` bigint NOT NULL,
  `teacher_id` bigint NOT NULL,
  `created_by` bigint DEFAULT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `attachment_size` bigint DEFAULT NULL,
  `attachment_type` varchar(255) DEFAULT NULL,
  `attachment_url` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6p1m72jobsvmrrn4bpj4168mg` (`course_id`),
  KEY `FK67msc7a52b0l2pttoq5bhm6bk` (`teacher_id`),
  KEY `FKotqcl7qkgnihgxa6x71is49i3` (`created_by`),
  CONSTRAINT `FK67msc7a52b0l2pttoq5bhm6bk` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FK6p1m72jobsvmrrn4bpj4168mg` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `FKotqcl7qkgnihgxa6x71is49i3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Table: submissions
-- ============================================
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` text,
  `submitted_at` datetime(6) DEFAULT NULL,
  `grade` int DEFAULT NULL,
  `graded` bit(1) DEFAULT NULL,
  `graded_at` datetime(6) DEFAULT NULL,
  `feedback` varchar(255) DEFAULT NULL,
  `assignment_id` bigint NOT NULL,
  `student_id` bigint NOT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `attachment_size` bigint DEFAULT NULL,
  `attachment_type` varchar(255) DEFAULT NULL,
  `attachment_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKrirbb44savy2g7nws0hoxs949` (`assignment_id`),
  KEY `FK3p6y8mnhpwusdgqrdl4hcl72m` (`student_id`),
  CONSTRAINT `FK3p6y8mnhpwusdgqrdl4hcl72m` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKrirbb44savy2g7nws0hoxs949` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Table: notes
-- ============================================
DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `visibility` varchar(255) NOT NULL,
  `author_id` bigint NOT NULL,
  `course_id` bigint DEFAULT NULL,
  `attachment_name` varchar(255) DEFAULT NULL,
  `attachment_size` bigint DEFAULT NULL,
  `attachment_type` varchar(255) DEFAULT NULL,
  `attachment_url` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKeequ6tj8iu98mxv7jr0nrb98n` (`author_id`),
  KEY `FKdn1o768ox9voi78asnp5mp4mw` (`course_id`),
  CONSTRAINT `FKdn1o768ox9voi78asnp5mp4mw` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `FKeequ6tj8iu98mxv7jr0nrb98n` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Table: study_materials
-- ============================================
DROP TABLE IF EXISTS `study_materials`;
CREATE TABLE `study_materials` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `course_id` bigint DEFAULT NULL,
  `teacher_id` bigint DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_size` bigint DEFAULT NULL,
  `file_type` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `teacher_id` (`teacher_id`),
  CONSTRAINT `study_materials_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `study_materials_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
-- ============================================
-- Insert Default Admin User
-- Email: admin@lms.com
-- Password: Admin@123
-- CHANGE THIS PASSWORD IMMEDIATELY AFTER FIRST LOGIN!
-- ============================================
INSERT INTO `users` (`name`, `email`, `password`, `role`, `status`)
VALUES (
    'System Administrator',
    'admin@lms.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZRGdjGj/n3.rL8vUqHLO8xBwOXzSK',
    'ADMIN',
    'ACTIVE'
  );
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */
;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */
;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */
;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
;
