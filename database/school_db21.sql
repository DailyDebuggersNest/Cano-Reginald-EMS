-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 18, 2026 at 03:11 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `school_db21`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_standings`
--

CREATE TABLE `academic_standings` (
  `standing_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` int(11) NOT NULL,
  `gpa` decimal(3,2) NOT NULL,
  `standing` enum('Good Standing','Dean''s List','With Honors','Probation','Dismissed','Warning') NOT NULL DEFAULT 'Good Standing',
  `total_units_taken` int(11) DEFAULT 0,
  `total_units_passed` int(11) DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `evaluated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `academic_standing_config`
--

CREATE TABLE `academic_standing_config` (
  `config_id` int(11) NOT NULL,
  `standing` enum('Good Standing','Dean''s List','With Honors','Probation','Dismissed','Warning') NOT NULL,
  `min_gpa` decimal(3,2) DEFAULT NULL,
  `max_gpa` decimal(3,2) DEFAULT NULL,
  `min_units` int(11) DEFAULT 0,
  `description` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academic_standing_config`
--

INSERT INTO `academic_standing_config` (`config_id`, `standing`, `min_gpa`, `max_gpa`, `min_units`, `description`, `priority`, `is_active`) VALUES
(1, 'Dean\'s List', 1.00, 1.45, 15, 'GPA 1.00-1.45 with minimum 15 units', 10, 1),
(2, 'With Honors', 1.46, 1.75, 15, 'GPA 1.46-1.75 with minimum 15 units', 9, 1),
(3, 'Good Standing', 1.76, 3.00, 0, 'GPA 1.76-3.00, passing all subjects', 5, 1),
(4, 'Warning', 3.01, 3.50, 0, 'GPA below 3.00 but above probation threshold', 3, 1),
(5, 'Probation', 3.51, 4.00, 0, 'GPA 3.51-4.00, at risk of dismissal', 2, 1),
(6, 'Dismissed', 4.01, 5.00, 0, 'Failed to meet minimum academic requirements', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `course_prerequisites`
--

CREATE TABLE `course_prerequisites` (
  `prereq_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `required_curriculum_id` int(11) NOT NULL,
  `min_grade` decimal(3,2) DEFAULT 3.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_prerequisites`
--

INSERT INTO `course_prerequisites` (`prereq_id`, `curriculum_id`, `required_curriculum_id`, `min_grade`, `created_at`) VALUES
(1, 2, 1, 3.00, '2026-01-30 14:34:11'),
(2, 17, 2, 3.00, '2026-01-30 14:34:11');

-- --------------------------------------------------------

--
-- Table structure for table `curriculum`
--

CREATE TABLE `curriculum` (
  `curriculum_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `course_code` varchar(50) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `year_level` int(11) NOT NULL,
  `semester` int(11) NOT NULL,
  `units` int(11) DEFAULT 3,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `prerequisite_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `curriculum`
--

INSERT INTO `curriculum` (`curriculum_id`, `program_id`, `course_code`, `course_name`, `year_level`, `semester`, `units`, `description`, `created_at`, `updated_at`, `prerequisite_id`) VALUES
(1, 1, 'IT 111', 'Introduction to Information Technology', 1, 1, 3, 'Basic concepts of IT and computer systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(2, 1, 'IT 112', 'Computer Fundamentals', 1, 1, 3, 'Introduction to computer hardware and software', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(3, 1, 'IT 113', 'Programming Fundamentals I', 1, 1, 3, 'Introduction to programming concepts and logic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(4, 1, 'IT 114', 'Mathematics for IT', 1, 1, 3, 'Mathematical foundations for IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(5, 1, 'IT 115', 'Computer Ethics', 1, 1, 3, 'Ethical issues in computing', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(6, 1, 'IT 116', 'English for IT', 1, 1, 3, 'Communication skills for IT professionals', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(7, 1, 'IT 117', 'Physical Education I', 1, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(8, 1, 'IT 118', 'National Service Training Program I', 1, 1, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(9, 1, 'IT 121', 'Programming Fundamentals II', 1, 2, 3, 'Advanced programming concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(10, 1, 'IT 122', 'Web Development Basics', 1, 2, 3, 'HTML, CSS, and JavaScript fundamentals', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(11, 1, 'IT 123', 'Database Fundamentals', 1, 2, 3, 'Introduction to database concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(12, 1, 'IT 124', 'Computer Networks Basics', 1, 2, 3, 'Introduction to networking concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(13, 1, 'IT 125', 'Data Structures Basics', 1, 2, 3, 'Introduction to data structures', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(14, 1, 'IT 126', 'IT Documentation', 1, 2, 3, 'Technical writing for IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(15, 1, 'IT 127', 'Physical Education II', 1, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(16, 1, 'IT 128', 'National Service Training Program II', 1, 2, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(17, 1, 'IT 211', 'Object-Oriented Programming', 2, 1, 3, 'OOP concepts and principles', '2026-01-21 13:46:23', '2026-01-21 15:25:18', 1),
(18, 1, 'IT 212', 'Data Structures and Algorithms', 2, 1, 3, 'Data structures and algorithm design', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(19, 1, 'IT 213', 'Database Management Systems', 2, 1, 3, 'Database design and SQL', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(20, 1, 'IT 214', 'Web Development', 2, 1, 3, 'Advanced web development techniques', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(21, 1, 'IT 215', 'Human-Computer Interaction', 2, 1, 3, 'User interface design principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(22, 1, 'IT 216', 'IT Project Management Basics', 2, 1, 3, 'Introduction to project management', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(23, 1, 'IT 217', 'Physical Education III', 2, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(24, 1, 'IT 218', 'Life and Works of Rizal', 2, 1, 3, 'Philippine history and culture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(25, 1, 'IT 221', 'System Analysis and Design', 2, 2, 3, 'Software development lifecycle', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(26, 1, 'IT 222', 'Network Fundamentals', 2, 2, 3, 'Computer networking principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(27, 1, 'IT 223', 'Operating Systems', 2, 2, 3, 'OS concepts and management', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(28, 1, 'IT 224', 'Software Engineering', 2, 2, 3, 'Software development methodologies', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(29, 1, 'IT 225', 'Web Application Development', 2, 2, 3, 'Building web applications', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(30, 1, 'IT 226', 'IT Security Basics', 2, 2, 3, 'Introduction to cybersecurity', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(31, 1, 'IT 227', 'Physical Education IV', 2, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(32, 1, 'IT 228', 'Philippine Literature', 2, 2, 3, 'Filipino literary works', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(33, 1, 'IT 311', 'Mobile Application Development', 3, 1, 3, 'Mobile app development concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(34, 1, 'IT 312', 'Information Security', 3, 1, 3, 'Cybersecurity fundamentals', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(35, 1, 'IT 313', 'Cloud Computing', 3, 1, 3, 'Cloud services and deployment', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(36, 1, 'IT 314', 'Web Application Development', 3, 1, 3, 'Advanced web application development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(37, 1, 'IT 315', 'System Integration', 3, 1, 3, 'Integrating IT systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(38, 1, 'IT 316', 'IT Quality Assurance', 3, 1, 3, 'Software testing and quality control', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(39, 1, 'IT 317', 'IT Elective I', 3, 1, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(40, 1, 'IT 318', 'IT Elective II', 3, 1, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(41, 1, 'IT 321', 'IT Project Management', 3, 2, 3, 'Project management in IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(42, 1, 'IT 322', 'Enterprise Systems', 3, 2, 3, 'Enterprise-level IT systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(43, 1, 'IT 323', 'IT Ethics and Legal Issues', 3, 2, 3, 'Ethical and legal aspects of IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(44, 1, 'IT 324', 'IT Research Methods', 3, 2, 3, 'Research methodologies in IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(45, 1, 'IT 325', 'IT Infrastructure Management', 3, 2, 3, 'Managing IT infrastructure', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(46, 1, 'IT 326', 'IT Service Management', 3, 2, 3, 'IT service delivery', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(47, 1, 'IT 327', 'IT Elective III', 3, 2, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(48, 1, 'IT 328', 'IT Elective IV', 3, 2, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(49, 1, 'IT 411', 'Capstone Project I', 4, 1, 3, 'Final year project part 1', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(50, 1, 'IT 412', 'IT Internship', 4, 1, 3, 'Industry internship program', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(51, 1, 'IT 413', 'Advanced Topics in IT', 4, 1, 3, 'Current trends and advanced topics', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(52, 1, 'IT 414', 'IT Governance', 4, 1, 3, 'IT management and governance', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(53, 1, 'IT 415', 'IT Strategic Planning', 4, 1, 3, 'Strategic IT planning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(54, 1, 'IT 416', 'IT Risk Management', 4, 1, 3, 'Managing IT risks', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(55, 1, 'IT 417', 'IT Elective V', 4, 1, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(56, 1, 'IT 418', 'IT Elective VI', 4, 1, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(57, 1, 'IT 421', 'Capstone Project II', 4, 2, 3, 'Final year project part 2', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(58, 1, 'IT 422', 'IT Entrepreneurship', 4, 2, 3, 'Starting IT businesses', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(59, 1, 'IT 423', 'Professional Practice', 4, 2, 3, 'Professional development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(60, 1, 'IT 424', 'IT Seminar', 4, 2, 3, 'Current issues and trends in IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(61, 1, 'IT 425', 'IT Portfolio Development', 4, 2, 3, 'Building professional portfolio', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(62, 1, 'IT 426', 'IT Career Development', 4, 2, 3, 'Career planning in IT', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(63, 1, 'IT 427', 'IT Elective VII', 4, 2, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(64, 1, 'IT 428', 'IT Elective VIII', 4, 2, 3, 'Specialized IT topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(65, 2, 'CS 111', 'Introduction to Computer Science', 1, 1, 3, 'Fundamentals of computer science', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(66, 2, 'CS 112', 'Programming I', 1, 1, 3, 'Introduction to programming', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(67, 2, 'CS 113', 'Discrete Mathematics', 1, 1, 3, 'Mathematical foundations for CS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(68, 2, 'CS 114', 'Computer Organization', 1, 1, 3, 'Computer hardware basics', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(69, 2, 'CS 115', 'Computer Ethics', 1, 1, 3, 'Ethical issues in computing', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(70, 2, 'CS 116', 'English for CS', 1, 1, 3, 'Communication skills for CS professionals', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(71, 2, 'CS 117', 'Physical Education I', 1, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(72, 2, 'CS 118', 'National Service Training Program I', 1, 1, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(73, 2, 'CS 121', 'Programming II', 1, 2, 3, 'Advanced programming concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(74, 2, 'CS 122', 'Data Structures', 1, 2, 3, 'Arrays, linked lists, trees, and graphs', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(75, 2, 'CS 123', 'Algorithms I', 1, 2, 3, 'Algorithm design and analysis', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(76, 2, 'CS 124', 'Digital Logic', 1, 2, 3, 'Digital logic design', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(77, 2, 'CS 125', 'Calculus for CS', 1, 2, 3, 'Mathematical calculus applications', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(78, 2, 'CS 126', 'CS Documentation', 1, 2, 3, 'Technical writing for CS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(79, 2, 'CS 127', 'Physical Education II', 1, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(80, 2, 'CS 128', 'National Service Training Program II', 1, 2, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(81, 2, 'CS 211', 'Object-Oriented Programming', 2, 1, 3, 'OOP concepts and principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(82, 2, 'CS 212', 'Algorithms II', 2, 1, 3, 'Advanced algorithm design', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(83, 2, 'CS 213', 'Computer Architecture', 2, 1, 3, 'Hardware and system organization', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(84, 2, 'CS 214', 'Database Systems', 2, 1, 3, 'Database design and implementation', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(85, 2, 'CS 215', 'Linear Algebra', 2, 1, 3, 'Mathematical foundations', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(86, 2, 'CS 216', 'Probability and Statistics', 2, 1, 3, 'Statistical methods for CS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(87, 2, 'CS 217', 'Physical Education III', 2, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(88, 2, 'CS 218', 'Life and Works of Rizal', 2, 1, 3, 'Philippine history and culture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(89, 2, 'CS 221', 'Operating Systems', 2, 2, 3, 'OS concepts and processes', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(90, 2, 'CS 222', 'Software Engineering', 2, 2, 3, 'Software development methodologies', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(91, 2, 'CS 223', 'Computer Networks', 2, 2, 3, 'Network protocols and architecture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(92, 2, 'CS 224', 'Theory of Computation', 2, 2, 3, 'Computational theory', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(93, 2, 'CS 225', 'Web Programming', 2, 2, 3, 'Web development fundamentals', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(94, 2, 'CS 226', 'CS Security Basics', 2, 2, 3, 'Introduction to computer security', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(95, 2, 'CS 227', 'Physical Education IV', 2, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(96, 2, 'CS 228', 'Philippine Literature', 2, 2, 3, 'Filipino literary works', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(97, 2, 'CS 311', 'Artificial Intelligence', 3, 1, 3, 'AI concepts and machine learning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(98, 2, 'CS 312', 'Computer Graphics', 3, 1, 3, 'Graphics programming and rendering', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(99, 2, 'CS 313', 'Compiler Design', 3, 1, 3, 'Compiler construction principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(100, 2, 'CS 314', 'Parallel Computing', 3, 1, 3, 'Parallel and distributed computing', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(101, 2, 'CS 315', 'Machine Learning', 3, 1, 3, 'ML algorithms and applications', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(102, 2, 'CS 316', 'Advanced Data Structures', 3, 1, 3, 'Complex data structures', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(103, 2, 'CS 317', 'CS Elective I', 3, 1, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(104, 2, 'CS 318', 'CS Elective II', 3, 1, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(105, 2, 'CS 321', 'Software Project Management', 3, 2, 3, 'Managing software projects', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(106, 2, 'CS 322', 'Human-Computer Interaction', 3, 2, 3, 'User interface design', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(107, 2, 'CS 323', 'CS Ethics', 3, 2, 3, 'Ethical issues in computing', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(108, 2, 'CS 324', 'CS Research Methods', 3, 2, 3, 'Research methodologies', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(109, 2, 'CS 325', 'Advanced Algorithms', 3, 2, 3, 'Complex algorithm design', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(110, 2, 'CS 326', 'Software Testing', 3, 2, 3, 'Testing methodologies', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(111, 2, 'CS 327', 'CS Elective III', 3, 2, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(112, 2, 'CS 328', 'CS Elective IV', 3, 2, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(113, 2, 'CS 411', 'Capstone Project I', 4, 1, 3, 'Final year project part 1', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(114, 2, 'CS 412', 'CS Internship', 4, 1, 3, 'Industry internship program', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(115, 2, 'CS 413', 'Advanced Algorithms', 4, 1, 3, 'Advanced algorithmic techniques', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(116, 2, 'CS 414', 'Distributed Systems', 4, 1, 3, 'Distributed computing systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(117, 2, 'CS 415', 'CS Strategic Planning', 4, 1, 3, 'Strategic planning in CS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(118, 2, 'CS 416', 'CS Risk Management', 4, 1, 3, 'Managing CS project risks', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(119, 2, 'CS 417', 'CS Elective V', 4, 1, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(120, 2, 'CS 418', 'CS Elective VI', 4, 1, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(121, 2, 'CS 421', 'Capstone Project II', 4, 2, 3, 'Final year project part 2', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(122, 2, 'CS 422', 'CS Entrepreneurship', 4, 2, 3, 'Starting tech businesses', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(123, 2, 'CS 423', 'Professional Practice', 4, 2, 3, 'Professional development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(124, 2, 'CS 424', 'CS Seminar', 4, 2, 3, 'Current trends in computer science', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(125, 2, 'CS 425', 'CS Portfolio Development', 4, 2, 3, 'Building professional portfolio', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(126, 2, 'CS 426', 'CS Career Development', 4, 2, 3, 'Career planning in CS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(127, 2, 'CS 427', 'CS Elective VII', 4, 2, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(128, 2, 'CS 428', 'CS Elective VIII', 4, 2, 3, 'Specialized CS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(129, 3, 'IS 111', 'Information Systems Fundamentals', 1, 1, 3, 'Introduction to information systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(130, 3, 'IS 112', 'Business Fundamentals', 1, 1, 3, 'Basic business concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(131, 3, 'IS 113', 'Programming for IS', 1, 1, 3, 'Programming for business applications', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(132, 3, 'IS 114', 'Mathematics for IS', 1, 1, 3, 'Mathematical foundations', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(133, 3, 'IS 115', 'IS Ethics', 1, 1, 3, 'Ethical issues in information systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(134, 3, 'IS 116', 'English for IS', 1, 1, 3, 'Communication skills for IS professionals', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(135, 3, 'IS 117', 'Physical Education I', 1, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(136, 3, 'IS 118', 'National Service Training Program I', 1, 1, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(137, 3, 'IS 121', 'Database Systems', 1, 2, 3, 'Database concepts for IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(138, 3, 'IS 122', 'Business Communication', 1, 2, 3, 'Effective business communication', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(139, 3, 'IS 123', 'Web Technologies', 1, 2, 3, 'Web development for business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(140, 3, 'IS 124', 'Business Statistics', 1, 2, 3, 'Statistical analysis for business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(141, 3, 'IS 125', 'Accounting Basics', 1, 2, 3, 'Basic accounting for IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(142, 3, 'IS 126', 'IS Documentation', 1, 2, 3, 'Technical writing for IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(143, 3, 'IS 127', 'Physical Education II', 1, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(144, 3, 'IS 128', 'National Service Training Program II', 1, 2, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(145, 3, 'IS 211', 'Business Process Management', 2, 1, 3, 'Business process analysis and design', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(146, 3, 'IS 212', 'Enterprise Architecture', 2, 1, 3, 'Organizational IT architecture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(147, 3, 'IS 213', 'Systems Analysis', 2, 1, 3, 'Analyzing business systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(148, 3, 'IS 214', 'Database Management', 2, 1, 3, 'Advanced database management', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(149, 3, 'IS 215', 'Business Law', 2, 1, 3, 'Legal aspects of business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(150, 3, 'IS 216', 'Financial Management Basics', 2, 1, 3, 'Financial concepts for IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(151, 3, 'IS 217', 'Physical Education III', 2, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(152, 3, 'IS 218', 'Life and Works of Rizal', 2, 1, 3, 'Philippine history and culture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(153, 3, 'IS 221', 'Data Analytics', 2, 2, 3, 'Data analysis and visualization', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(154, 3, 'IS 222', 'E-Commerce Systems', 2, 2, 3, 'Online business systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(155, 3, 'IS 223', 'Management Information Systems', 2, 2, 3, 'MIS concepts and applications', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(156, 3, 'IS 224', 'Business Intelligence', 2, 2, 3, 'BI tools and techniques', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(157, 3, 'IS 225', 'Systems Design', 2, 2, 3, 'Designing information systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(158, 3, 'IS 226', 'IS Security Basics', 2, 2, 3, 'Introduction to IS security', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(159, 3, 'IS 227', 'Physical Education IV', 2, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(160, 3, 'IS 228', 'Philippine Literature', 2, 2, 3, 'Filipino literary works', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(161, 3, 'IS 311', 'IT Governance', 3, 1, 3, 'IT management and governance', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(162, 3, 'IS 312', 'Systems Integration', 3, 1, 3, 'Integrating business systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(163, 3, 'IS 313', 'IS Project Management', 3, 1, 3, 'Managing IS projects', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(164, 3, 'IS 314', 'Enterprise Resource Planning', 3, 1, 3, 'ERP systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(165, 3, 'IS 315', 'Business Analytics', 3, 1, 3, 'Advanced business analytics', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(166, 3, 'IS 316', 'IS Quality Assurance', 3, 1, 3, 'Quality control in IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(167, 3, 'IS 317', 'IS Elective I', 3, 1, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(168, 3, 'IS 318', 'IS Elective II', 3, 1, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(169, 3, 'IS 321', 'IS Security', 3, 2, 3, 'Information systems security', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(170, 3, 'IS 322', 'IS Strategy', 3, 2, 3, 'Strategic IS planning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(171, 3, 'IS 323', 'IS Ethics', 3, 2, 3, 'Ethical issues in IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(172, 3, 'IS 324', 'IS Research Methods', 3, 2, 3, 'Research methodologies', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(173, 3, 'IS 325', 'IS Infrastructure Management', 3, 2, 3, 'Managing IS infrastructure', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(174, 3, 'IS 326', 'IS Service Management', 3, 2, 3, 'IS service delivery', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(175, 3, 'IS 327', 'IS Elective III', 3, 2, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(176, 3, 'IS 328', 'IS Elective IV', 3, 2, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(177, 3, 'IS 411', 'Capstone Project I', 4, 1, 3, 'Final year project part 1', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(178, 3, 'IS 412', 'IS Internship', 4, 1, 3, 'Industry internship program', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(179, 3, 'IS 413', 'Advanced IS Topics', 4, 1, 3, 'Current trends in IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(180, 3, 'IS 414', 'IS Consulting', 4, 1, 3, 'IS consulting practices', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(181, 3, 'IS 415', 'IS Strategic Planning', 4, 1, 3, 'Strategic IS planning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(182, 3, 'IS 416', 'IS Risk Management', 4, 1, 3, 'Managing IS risks', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(183, 3, 'IS 417', 'IS Elective V', 4, 1, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(184, 3, 'IS 418', 'IS Elective VI', 4, 1, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(185, 3, 'IS 421', 'Capstone Project II', 4, 2, 3, 'Final year project part 2', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(186, 3, 'IS 422', 'IS Entrepreneurship', 4, 2, 3, 'Starting IS businesses', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(187, 3, 'IS 423', 'Professional Practice', 4, 2, 3, 'Professional development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(188, 3, 'IS 424', 'IS Seminar', 4, 2, 3, 'Current issues in information systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(189, 3, 'IS 425', 'IS Portfolio Development', 4, 2, 3, 'Building professional portfolio', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(190, 3, 'IS 426', 'IS Career Development', 4, 2, 3, 'Career planning in IS', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(191, 3, 'IS 427', 'IS Elective VII', 4, 2, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(192, 3, 'IS 428', 'IS Elective VIII', 4, 2, 3, 'Specialized IS topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(193, 4, 'BA 111', 'Business Fundamentals', 1, 1, 3, 'Introduction to business concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(194, 4, 'BA 112', 'Principles of Management', 1, 1, 3, 'Management theories and practices', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(195, 4, 'BA 113', 'Business Mathematics', 1, 1, 3, 'Mathematical applications in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(196, 4, 'BA 114', 'Business Communication', 1, 1, 3, 'Effective business communication', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(197, 4, 'BA 115', 'Business Ethics', 1, 1, 3, 'Ethical issues in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(198, 4, 'BA 116', 'English for Business', 1, 1, 3, 'Communication skills for business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(199, 4, 'BA 117', 'Physical Education I', 1, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(200, 4, 'BA 118', 'National Service Training Program I', 1, 1, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(201, 4, 'BA 121', 'Marketing Fundamentals', 1, 2, 3, 'Introduction to marketing', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(202, 4, 'BA 122', 'Accounting Principles', 1, 2, 3, 'Basic accounting concepts', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(203, 4, 'BA 123', 'Business Statistics', 1, 2, 3, 'Statistical analysis for business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(204, 4, 'BA 124', 'Economics Fundamentals', 1, 2, 3, 'Basic economic principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(205, 4, 'BA 125', 'Business Law Basics', 1, 2, 3, 'Introduction to business law', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(206, 4, 'BA 126', 'Business Documentation', 1, 2, 3, 'Business writing skills', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(207, 4, 'BA 127', 'Physical Education II', 1, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(208, 4, 'BA 128', 'National Service Training Program II', 1, 2, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(209, 4, 'BA 211', 'Marketing Management', 2, 1, 3, 'Marketing strategies and principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(210, 4, 'BA 212', 'Financial Management', 2, 1, 3, 'Financial planning and analysis', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(211, 4, 'BA 213', 'Human Resource Management', 2, 1, 3, 'HR principles and practices', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(212, 4, 'BA 214', 'Operations Management', 2, 1, 3, 'Business operations and processes', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(213, 4, 'BA 215', 'Business Finance', 2, 1, 3, 'Financial management principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(214, 4, 'BA 216', 'Business Psychology', 2, 1, 3, 'Psychology in business context', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(215, 4, 'BA 217', 'Physical Education III', 2, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(216, 4, 'BA 218', 'Life and Works of Rizal', 2, 1, 3, 'Philippine history and culture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(217, 4, 'BA 221', 'Business Law', 2, 2, 3, 'Legal aspects of business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(218, 4, 'BA 222', 'Organizational Behavior', 2, 2, 3, 'Understanding organizational dynamics', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(219, 4, 'BA 223', 'Business Research', 2, 2, 3, 'Research methods in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(220, 4, 'BA 224', 'Business Information Systems', 2, 2, 3, 'IT in business context', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(221, 4, 'BA 225', 'Business Analytics', 2, 2, 3, 'Data-driven business decisions', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(222, 4, 'BA 226', 'Business Security Basics', 2, 2, 3, 'Business security principles', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(223, 4, 'BA 227', 'Physical Education IV', 2, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(224, 4, 'BA 228', 'Philippine Literature', 2, 2, 3, 'Filipino literary works', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(225, 4, 'BA 311', 'Business Ethics', 3, 1, 3, 'Ethical business practices', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(226, 4, 'BA 312', 'Strategic Management', 3, 1, 3, 'Strategic planning and execution', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(227, 4, 'BA 313', 'Entrepreneurship', 3, 1, 3, 'Starting and managing businesses', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(228, 4, 'BA 314', 'International Business', 3, 1, 3, 'Global business practices', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(229, 4, 'BA 315', 'Business Strategy', 3, 1, 3, 'Strategic business planning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(230, 4, 'BA 316', 'Business Quality Assurance', 3, 1, 3, 'Quality control in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(231, 4, 'BA 317', 'BA Elective I', 3, 1, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(232, 4, 'BA 318', 'BA Elective II', 3, 1, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(233, 4, 'BA 321', 'Business Analytics', 3, 2, 3, 'Data-driven business decisions', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(234, 4, 'BA 322', 'Project Management', 3, 2, 3, 'Managing business projects', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(235, 4, 'BA 323', 'Business Negotiation', 3, 2, 3, 'Negotiation skills', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(236, 4, 'BA 324', 'Business Innovation', 3, 2, 3, 'Innovation in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(237, 4, 'BA 325', 'Business Infrastructure', 3, 2, 3, 'Business infrastructure management', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(238, 4, 'BA 326', 'Business Service Management', 3, 2, 3, 'Service delivery in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(239, 4, 'BA 327', 'BA Elective III', 3, 2, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(240, 4, 'BA 328', 'BA Elective IV', 3, 2, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(241, 4, 'BA 411', 'Capstone Project I', 4, 1, 3, 'Final year project part 1', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(242, 4, 'BA 412', 'Business Internship', 4, 1, 3, 'Industry internship program', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(243, 4, 'BA 413', 'Advanced Business Topics', 4, 1, 3, 'Current trends in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(244, 4, 'BA 414', 'Business Consulting', 4, 1, 3, 'Business consulting practices', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(245, 4, 'BA 415', 'Business Strategic Planning', 4, 1, 3, 'Strategic business planning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(246, 4, 'BA 416', 'Business Risk Management', 4, 1, 3, 'Managing business risks', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(247, 4, 'BA 417', 'BA Elective V', 4, 1, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(248, 4, 'BA 418', 'BA Elective VI', 4, 1, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(249, 4, 'BA 421', 'Capstone Project II', 4, 2, 3, 'Final year project part 2', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(250, 4, 'BA 422', 'Business Leadership', 4, 2, 3, 'Leadership in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(251, 4, 'BA 423', 'Professional Practice', 4, 2, 3, 'Professional development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(252, 4, 'BA 424', 'Business Seminar', 4, 2, 3, 'Current issues in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(253, 4, 'BA 425', 'Business Portfolio Development', 4, 2, 3, 'Building professional portfolio', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(254, 4, 'BA 426', 'Business Career Development', 4, 2, 3, 'Career planning in business', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(255, 4, 'BA 427', 'BA Elective VII', 4, 2, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(256, 4, 'BA 428', 'BA Elective VIII', 4, 2, 3, 'Specialized business topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(257, 5, 'ED 111', 'Principles of Education', 1, 1, 3, 'Foundations of education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(258, 5, 'ED 112', 'Educational Psychology', 1, 1, 3, 'Psychology in learning and teaching', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(259, 5, 'ED 113', 'Child Development', 1, 1, 3, 'Understanding child development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(260, 5, 'ED 114', 'Introduction to Teaching', 1, 1, 3, 'Introduction to teaching profession', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(261, 5, 'ED 115', 'Education Ethics', 1, 1, 3, 'Ethical issues in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(262, 5, 'ED 116', 'English for Education', 1, 1, 3, 'Communication skills for educators', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(263, 5, 'ED 117', 'Physical Education I', 1, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(264, 5, 'ED 118', 'National Service Training Program I', 1, 1, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(265, 5, 'ED 121', 'Curriculum Development', 1, 2, 3, 'Designing educational curricula', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(266, 5, 'ED 122', 'Teaching Methods', 1, 2, 3, 'Pedagogical approaches and techniques', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(267, 5, 'ED 123', 'Classroom Management', 1, 2, 3, 'Managing classroom environments', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(268, 5, 'ED 124', 'Educational Technology Basics', 1, 2, 3, 'Technology in education basics', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(269, 5, 'ED 125', 'Learning Theories', 1, 2, 3, 'Theories of learning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(270, 5, 'ED 126', 'Education Documentation', 1, 2, 3, 'Educational writing skills', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(271, 5, 'ED 127', 'Physical Education II', 1, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(272, 5, 'ED 128', 'National Service Training Program II', 1, 2, 3, 'Civic welfare training', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(273, 5, 'ED 211', 'Assessment and Evaluation', 2, 1, 3, 'Student assessment methods', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(274, 5, 'ED 212', 'Special Education', 2, 1, 3, 'Teaching students with special needs', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(275, 5, 'ED 213', 'Educational Research', 2, 1, 3, 'Research methods in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(276, 5, 'ED 214', 'Learning Theories', 2, 1, 3, 'Theories of learning', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(277, 5, 'ED 215', 'Education Law', 2, 1, 3, 'Legal aspects of education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(278, 5, 'ED 216', 'Education Psychology Advanced', 2, 1, 3, 'Advanced educational psychology', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(279, 5, 'ED 217', 'Physical Education III', 2, 1, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(280, 5, 'ED 218', 'Life and Works of Rizal', 2, 1, 3, 'Philippine history and culture', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(281, 5, 'ED 221', 'Educational Technology', 2, 2, 3, 'Advanced technology in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(282, 5, 'ED 222', 'Subject Matter Methods', 2, 2, 3, 'Teaching specific subjects', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(283, 5, 'ED 223', 'Educational Measurement', 2, 2, 3, 'Measuring educational outcomes', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(284, 5, 'ED 224', 'Educational Planning', 2, 2, 3, 'Planning educational programs', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(285, 5, 'ED 225', 'Instructional Design', 2, 2, 3, 'Designing instructional materials', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(286, 5, 'ED 226', 'Education Security Basics', 2, 2, 3, 'Security in educational settings', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(287, 5, 'ED 227', 'Physical Education IV', 2, 2, 3, 'Physical fitness and wellness', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(288, 5, 'ED 228', 'Philippine Literature', 2, 2, 3, 'Filipino literary works', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(289, 5, 'ED 311', 'Professional Ethics in Education', 3, 1, 3, 'Ethics for educators', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(290, 5, 'ED 312', 'Educational Leadership', 3, 1, 3, 'Leadership in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(291, 5, 'ED 313', 'Comparative Education', 3, 1, 3, 'Comparing educational systems', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(292, 5, 'ED 314', 'Educational Innovation', 3, 1, 3, 'Innovation in teaching', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(293, 5, 'ED 315', 'Education Strategy', 3, 1, 3, 'Strategic planning in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(294, 5, 'ED 316', 'Education Quality Assurance', 3, 1, 3, 'Quality control in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(295, 5, 'ED 317', 'ED Elective I', 3, 1, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(296, 5, 'ED 318', 'ED Elective II', 3, 1, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(297, 5, 'ED 321', 'Teaching Practice I', 3, 2, 3, 'Teaching practicum part 1', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(298, 5, 'ED 322', 'Educational Policy', 3, 2, 3, 'Education policy analysis', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(299, 5, 'ED 323', 'Multicultural Education', 3, 2, 3, 'Teaching diverse learners', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(300, 5, 'ED 324', 'Educational Assessment', 3, 2, 3, 'Advanced assessment techniques', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(301, 5, 'ED 325', 'Education Infrastructure', 3, 2, 3, 'Managing educational infrastructure', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(302, 5, 'ED 326', 'Education Service Management', 3, 2, 3, 'Service delivery in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(303, 5, 'ED 327', 'ED Elective III', 3, 2, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(304, 5, 'ED 328', 'ED Elective IV', 3, 2, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(305, 5, 'ED 411', 'Capstone Project I', 4, 1, 3, 'Final year project part 1', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(306, 5, 'ED 412', 'Teaching Practice II', 4, 1, 3, 'Teaching practicum part 2', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(307, 5, 'ED 413', 'Advanced Teaching Methods', 4, 1, 3, 'Advanced pedagogical techniques', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(308, 5, 'ED 414', 'Educational Management', 4, 1, 3, 'Managing educational institutions', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(309, 5, 'ED 415', 'Education Strategic Planning', 4, 1, 3, 'Strategic planning in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(310, 5, 'ED 416', 'Education Risk Management', 4, 1, 3, 'Managing educational risks', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(311, 5, 'ED 417', 'ED Elective V', 4, 1, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(312, 5, 'ED 418', 'ED Elective VI', 4, 1, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(313, 5, 'ED 421', 'Capstone Project II', 4, 2, 3, 'Final year project part 2', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(314, 5, 'ED 422', 'Professional Development', 4, 2, 3, 'Continuing professional development', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(315, 5, 'ED 423', 'Educational Research Project', 4, 2, 3, 'Research project in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(316, 5, 'ED 424', 'Education Seminar', 4, 2, 3, 'Current issues in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(317, 5, 'ED 425', 'Education Portfolio Development', 4, 2, 3, 'Building professional portfolio', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(318, 5, 'ED 426', 'Education Career Development', 4, 2, 3, 'Career planning in education', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(319, 5, 'ED 427', 'ED Elective VII', 4, 2, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL),
(320, 5, 'ED 428', 'ED Elective VIII', 4, 2, 3, 'Specialized education topic', '2026-01-21 13:46:23', '2026-01-21 13:46:23', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `midterm_grade` decimal(3,2) DEFAULT NULL,
  `final_grade` decimal(3,2) DEFAULT NULL,
  `status` enum('Enrolled','Passed','Failed') DEFAULT 'Enrolled',
  `enrolled_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`enrollment_id`, `student_id`, `curriculum_id`, `academic_year`, `midterm_grade`, `final_grade`, `status`, `enrolled_at`, `updated_at`) VALUES
(41, 5, 65, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(42, 5, 66, '2025-2026', 1.75, 1.50, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(43, 5, 67, '2025-2026', 2.00, 1.75, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(44, 5, 68, '2025-2026', 1.25, 1.25, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(45, 5, 69, '2025-2026', 1.50, 1.50, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(47, 5, 71, '2025-2026', 2.25, 2.00, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(48, 5, 72, '2025-2026', 1.75, 1.50, 'Passed', '2026-01-25 07:15:46', '2026-01-30 15:34:29'),
(49, 5, 70, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 07:22:26', '2026-01-30 15:34:29'),
(58, 5, 73, '2025-2026', 1.25, 1.25, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(59, 5, 74, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(60, 5, 75, '2025-2026', 1.75, 1.50, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(61, 5, 76, '2025-2026', 2.00, 1.75, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(62, 5, 77, '2025-2026', 1.50, 1.50, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(63, 5, 78, '2025-2026', 1.75, 1.50, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(64, 5, 79, '2025-2026', 2.00, 1.75, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(65, 5, 80, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 07:35:40', '2026-01-30 15:34:29'),
(66, 5, 81, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(67, 5, 82, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(68, 5, 83, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(69, 5, 84, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(70, 5, 85, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(71, 5, 86, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(72, 5, 87, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(73, 5, 88, '2026-2027', NULL, NULL, 'Enrolled', '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(74, 9, 57, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(75, 9, 58, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(76, 9, 59, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(77, 9, 60, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(78, 9, 61, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(79, 9, 62, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(80, 9, 63, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(81, 9, 64, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(82, 8, 65, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(83, 8, 66, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(84, 8, 67, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(85, 8, 68, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(86, 8, 69, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(87, 8, 70, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(88, 8, 71, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(89, 8, 72, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(90, 7, 113, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(91, 7, 114, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(92, 7, 115, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(93, 7, 116, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(94, 7, 117, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(95, 7, 118, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(96, 7, 119, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(97, 7, 120, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(106, 12, 1, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(107, 12, 2, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(108, 12, 3, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(109, 12, 4, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(110, 12, 5, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(111, 12, 6, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(112, 12, 7, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(113, 12, 8, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(114, 10, 33, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(115, 10, 34, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(116, 10, 35, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(117, 10, 36, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(118, 10, 37, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(119, 10, 38, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(120, 10, 39, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(121, 10, 40, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(122, 11, 1, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(123, 11, 2, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(124, 11, 3, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(125, 11, 4, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(126, 11, 5, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(127, 11, 6, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(128, 11, 7, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(129, 11, 8, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(130, 23, 273, '2025-2026', 1.25, 1.00, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(131, 23, 274, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(132, 23, 275, '2025-2026', 1.25, 1.25, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(133, 23, 276, '2025-2026', 1.75, 1.50, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(134, 23, 277, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(135, 23, 278, '2025-2026', 1.25, 1.00, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(136, 23, 279, '2025-2026', 1.50, 1.50, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(137, 23, 280, '2025-2026', 1.75, 1.25, 'Passed', '2026-01-25 08:00:36', '2026-01-30 15:34:46'),
(138, 16, 129, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(139, 16, 130, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(140, 16, 131, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(141, 16, 132, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(142, 16, 133, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(143, 16, 134, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(144, 16, 135, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(145, 16, 136, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(146, 19, 201, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(147, 19, 202, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(148, 19, 203, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(149, 19, 204, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(150, 19, 205, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(151, 19, 206, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(152, 19, 207, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(153, 19, 208, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(154, 24, 257, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(155, 24, 258, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(156, 24, 259, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(157, 24, 260, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(158, 24, 261, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(159, 24, 262, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(160, 24, 263, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(161, 24, 264, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(162, 14, 145, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(163, 14, 146, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(164, 14, 147, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(165, 14, 148, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(166, 14, 149, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(167, 14, 150, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(168, 14, 151, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(169, 14, 152, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(170, 21, 289, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(171, 21, 290, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(172, 21, 291, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(173, 21, 292, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(174, 21, 293, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(175, 21, 294, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(176, 21, 295, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(177, 21, 296, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(178, 23, 281, '2025-2026', 1.25, 1.25, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(179, 23, 282, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(180, 23, 283, '2025-2026', 1.00, 1.00, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(181, 23, 284, '2025-2026', 1.25, 1.25, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(182, 23, 285, '2025-2026', 1.75, 1.50, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(183, 23, 286, '2025-2026', 1.50, 1.25, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(184, 23, 287, '2025-2026', 1.25, 1.00, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(185, 23, 288, '2025-2026', 1.50, 1.50, 'Passed', '2026-01-25 08:18:19', '2026-01-30 15:34:46'),
(186, 23, 289, '2026-2027', 1.00, 1.25, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:44:48'),
(187, 23, 290, '2026-2027', 1.50, 1.75, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(188, 23, 291, '2026-2027', 1.50, 1.25, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(189, 23, 292, '2026-2027', 1.00, 1.75, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(190, 23, 293, '2026-2027', 1.25, 1.50, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(191, 23, 294, '2026-2027', 1.50, 1.50, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(192, 23, 295, '2026-2027', 1.75, 1.25, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(193, 23, 296, '2026-2027', 1.00, 1.25, 'Passed', '2026-01-25 08:18:50', '2026-02-02 12:45:45'),
(210, 22, 305, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(211, 22, 306, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(212, 22, 307, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(213, 22, 308, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(214, 22, 309, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(215, 22, 310, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(216, 22, 311, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(217, 22, 312, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(218, 13, 177, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(219, 13, 178, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(220, 13, 179, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(221, 13, 180, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(222, 13, 181, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(223, 13, 182, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(224, 13, 183, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(225, 13, 184, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(226, 15, 145, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(227, 15, 146, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(228, 15, 147, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(229, 15, 148, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(230, 15, 149, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(231, 15, 150, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(232, 15, 151, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(233, 15, 152, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(234, 17, 193, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(235, 17, 194, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(236, 17, 195, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(237, 17, 196, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(238, 17, 197, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(239, 17, 198, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(240, 17, 199, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(241, 17, 200, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(242, 20, 209, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(243, 20, 210, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(244, 20, 211, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(245, 20, 212, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(246, 20, 213, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(247, 20, 214, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(248, 20, 215, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(249, 20, 216, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(250, 18, 241, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(251, 18, 242, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(252, 18, 243, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(253, 18, 244, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(254, 18, 245, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(255, 18, 246, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(256, 18, 247, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(257, 18, 248, '2025-2026', NULL, NULL, 'Enrolled', '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(259, 23, 297, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(260, 23, 298, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(261, 23, 299, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(262, 23, 300, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(263, 23, 301, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(264, 23, 302, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(265, 23, 303, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(266, 23, 304, '2026-2027', NULL, NULL, 'Enrolled', '2026-02-02 12:33:19', '2026-02-02 12:33:19'),
(267, 25, 65, '2025-2026', 3.00, 3.00, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(268, 25, 66, '2025-2026', 3.00, 3.00, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(269, 25, 67, '2025-2026', 2.75, 1.50, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(270, 25, 68, '2025-2026', 1.25, 1.00, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(271, 25, 69, '2025-2026', 2.00, 2.50, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(272, 25, 70, '2025-2026', 2.75, 2.50, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(273, 25, 71, '2025-2026', 2.25, 3.00, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(274, 25, 72, '2025-2026', 2.75, 3.00, 'Passed', '2026-02-02 12:34:05', '2026-02-02 13:37:32'),
(283, 26, 65, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(284, 26, 66, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(285, 26, 67, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(286, 26, 68, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(287, 26, 69, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(288, 26, 70, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(289, 26, 71, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46'),
(290, 26, 72, '2025-2026', NULL, NULL, 'Enrolled', '2026-02-02 14:31:46', '2026-02-02 14:31:46');

-- --------------------------------------------------------

--
-- Table structure for table `fees`
--

CREATE TABLE `fees` (
  `fee_id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `type` enum('per_unit','fixed') NOT NULL DEFAULT 'fixed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fees`
--

INSERT INTO `fees` (`fee_id`, `code`, `description`, `amount`, `type`) VALUES
(1, 'TUITION', 'Tuition Fee (per unit) - Base Rate', 800.00, 'per_unit'),
(2, 'REG', 'Registration Fee', 450.00, 'fixed'),
(3, 'LIB', 'Library Fee', 850.00, 'fixed'),
(4, 'MED', 'Medical & Dental Fee', 400.00, 'fixed'),
(5, 'ATH', 'Athletic Fee', 350.00, 'fixed'),
(6, 'CUL', 'Cultural Fee', 200.00, 'fixed'),
(7, 'SSC', 'Student Council Fee', 150.00, 'fixed'),
(8, 'ENE', 'Energy Fee', 1200.00, 'fixed'),
(9, 'NET', 'Internet & Connectivity Fee', 600.00, 'fixed'),
(10, 'ID', 'ID Validation', 100.00, 'fixed'),
(11, 'LAB', 'Laboratory Fee', 2000.00, 'fixed'),
(12, 'MISC', 'Miscellaneous Fee', 1200.00, 'fixed');

-- --------------------------------------------------------

--
-- Table structure for table `late_fee_config`
--

CREATE TABLE `late_fee_config` (
  `config_id` int(11) NOT NULL,
  `fee_type` enum('percentage','fixed') NOT NULL DEFAULT 'percentage',
  `fee_value` decimal(10,2) NOT NULL DEFAULT 5.00,
  `grace_period_days` int(11) DEFAULT 30,
  `max_penalty_percent` decimal(5,2) DEFAULT 25.00,
  `apply_per` enum('month','week','once') DEFAULT 'month',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `late_fee_config`
--

INSERT INTO `late_fee_config` (`config_id`, `fee_type`, `fee_value`, `grace_period_days`, `max_penalty_percent`, `apply_per`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'percentage', 5.00, 30, 25.00, 'month', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime DEFAULT current_timestamp(),
  `academic_year` varchar(20) NOT NULL,
  `semester` int(11) NOT NULL,
  `reference_no` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `student_id`, `amount`, `payment_date`, `academic_year`, `semester`, `reference_no`, `notes`) VALUES
(8, 5, 26700.00, '2026-01-25 15:35:06', '2025-2026', 1, NULL, ''),
(9, 5, 26700.00, '2026-01-25 15:35:54', '2025-2026', 2, NULL, ''),
(11, 23, 26700.00, '2026-01-25 16:17:58', '2025-2026', 1, NULL, ''),
(12, 23, 26700.00, '2026-01-25 16:18:27', '2025-2026', 2, NULL, ''),
(13, 23, 20000.00, '2026-01-25 16:19:01', '2026-2027', 1, NULL, ''),
(14, 23, 20000.00, '2026-01-31 00:29:57', '2026-2027', 1, NULL, ''),
(15, 23, 10000.00, '2026-01-31 00:30:30', '2026-2027', 1, NULL, ''),
(16, 23, 10000.00, '2026-01-31 00:49:40', '2026-2027', 2, NULL, ''),
(17, 23, 2000.00, '2026-01-31 01:00:37', '2026-2027', 2, NULL, ''),
(19, 5, 15200.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-5-202520261', 'Full payment - Data cleanup for program tuition update'),
(20, 5, 15200.00, '2026-01-31 00:00:00', '2025-2026', 2, 'PAY-20260130-5-202520262', 'Full payment - Data cleanup for program tuition update'),
(21, 5, 41900.00, '2026-01-31 00:00:00', '2026-2027', 1, 'PAY-20260130-5-202620271', 'Full payment - Data cleanup for program tuition update'),
(23, 7, 41900.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-7-202520261', 'Full payment - Data cleanup for program tuition update'),
(24, 8, 41900.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-8-202520261', 'Full payment - Data cleanup for program tuition update'),
(25, 9, 37800.00, '2026-01-31 00:00:00', '2025-2026', 2, 'PAY-20260130-9-202520262', 'Full payment - Data cleanup for program tuition update'),
(26, 10, 37800.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-10-202520261', 'Full payment - Data cleanup for program tuition update'),
(27, 11, 37800.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-11-202520261', 'Full payment - Data cleanup for program tuition update'),
(28, 12, 37800.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-12-202520261', 'Full payment - Data cleanup for program tuition update'),
(29, 13, 34400.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-13-202520261', 'Full payment - Data cleanup for program tuition update'),
(30, 14, 34400.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-14-202520261', 'Full payment - Data cleanup for program tuition update'),
(31, 15, 34400.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-15-202520261', 'Full payment - Data cleanup for program tuition update'),
(32, 16, 34400.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-16-202520261', 'Full payment - Data cleanup for program tuition update'),
(33, 17, 28600.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-17-202520261', 'Full payment - Data cleanup for program tuition update'),
(34, 18, 28600.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-18-202520261', 'Full payment - Data cleanup for program tuition update'),
(35, 19, 28600.00, '2026-01-31 00:00:00', '2025-2026', 2, 'PAY-20260130-19-202520262', 'Full payment - Data cleanup for program tuition update'),
(36, 20, 28600.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-20-202520261', 'Full payment - Data cleanup for program tuition update'),
(37, 21, 24500.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-21-202520261', 'Full payment - Data cleanup for program tuition update'),
(38, 22, 24500.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-22-202520261', 'Full payment - Data cleanup for program tuition update'),
(39, 24, 24500.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-24-202520261', 'Full payment - Data cleanup for program tuition update'),
(40, 25, 41900.00, '2026-01-31 00:00:00', '2025-2026', 1, 'PAY-20260130-25-202520261', 'Full payment - Data cleanup for program tuition update'),
(43, 26, 20000.00, '2026-02-02 22:55:33', '2025-2026', 1, NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `program_id` int(11) NOT NULL,
  `program_code` varchar(50) NOT NULL,
  `program_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`program_id`, `program_code`, `program_name`, `description`, `created_at`) VALUES
(1, 'BSIT', 'Bachelor of Science in Information Technology', 'Focuses on software development, networking, database management, and IT support. Prepares graduates for careers in tech industry.', '2026-01-21 13:46:23'),
(2, 'BSCS', 'Bachelor of Science in Computer Science', 'Emphasizes algorithms, programming, AI, and software engineering. Prepares students for advanced computing and research roles.', '2026-01-21 13:46:23'),
(3, 'BSIS', 'Bachelor of Science in Information Systems', 'Combines business and technology with focus on systems analysis, database design, and IT project management.', '2026-01-21 13:46:23'),
(4, 'BSBA', 'Bachelor of Science in Business Administration', 'Covers management, marketing, finance, and entrepreneurship. Prepares students for leadership roles in business.', '2026-01-21 13:46:23'),
(5, 'BSE', 'Bachelor of Science in Education', 'Prepares students for teaching careers in elementary and secondary education with focus on pedagogy and curriculum.', '2026-01-21 13:46:23');

-- --------------------------------------------------------

--
-- Table structure for table `program_tuition_rates`
--

CREATE TABLE `program_tuition_rates` (
  `rate_id` int(11) NOT NULL,
  `program_id` int(11) NOT NULL,
  `tuition_per_unit` decimal(10,2) NOT NULL DEFAULT 800.00,
  `lab_fee` decimal(10,2) NOT NULL DEFAULT 2000.00,
  `effective_date` date NOT NULL DEFAULT '2025-01-01',
  `is_active` tinyint(1) DEFAULT 1,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `program_tuition_rates`
--

INSERT INTO `program_tuition_rates` (`rate_id`, `program_id`, `tuition_per_unit`, `lab_fee`, `effective_date`, `is_active`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1200.00, 3500.00, '2025-01-01', 1, 'BSIT - Information Technology (Higher rate for tech equipment)', '2026-01-30 16:45:18', '2026-01-30 16:45:18'),
(2, 2, 1350.00, 4000.00, '2025-01-01', 1, 'BSCS - Computer Science (Highest rate - advanced computing resources)', '2026-01-30 16:45:18', '2026-01-30 16:45:18'),
(3, 3, 1100.00, 2500.00, '2025-01-01', 1, 'BSIS - Information Systems (Moderate tech rate)', '2026-01-30 16:45:18', '2026-01-30 16:45:18'),
(4, 4, 900.00, 1500.00, '2025-01-01', 1, 'BSBA - Business Administration (Standard business rate)', '2026-01-30 16:45:18', '2026-01-30 16:45:18'),
(5, 5, 750.00, 1000.00, '2025-01-01', 1, 'BSE - Education (Lower rate for education program)', '2026-01-30 16:45:18', '2026-01-30 16:45:18');

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `schedule_id` int(11) NOT NULL,
  `curriculum_id` int(11) NOT NULL,
  `day_of_week` enum('Mon','Tue','Wed','Thu','Fri','Sat','Sun') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `room` varchar(50) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `capacity` int(11) DEFAULT 40,
  `enrolled_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`schedule_id`, `curriculum_id`, `day_of_week`, `start_time`, `end_time`, `room`, `teacher_id`, `created_at`, `capacity`, `enrolled_count`) VALUES
(1, 1, 'Mon', '08:00:00', '09:30:00', 'Room 101', 1, '2026-01-21 13:46:23', 40, 2),
(2, 1, 'Wed', '08:00:00', '09:30:00', 'Room 101', 1, '2026-01-21 13:46:23', 40, 2),
(3, 2, 'Mon', '09:30:00', '11:00:00', 'Lab 1', 2, '2026-01-21 13:46:23', 40, 2),
(4, 2, 'Thu', '09:30:00', '11:00:00', 'Lab 1', 2, '2026-01-21 13:46:23', 40, 2),
(5, 3, 'Tue', '08:00:00', '09:30:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 2),
(6, 3, 'Fri', '08:00:00', '09:30:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 2),
(7, 4, 'Tue', '09:30:00', '11:00:00', 'Room 102', 4, '2026-01-21 13:46:23', 40, 2),
(8, 4, 'Mon', '11:00:00', '12:30:00', 'Room 102', 4, '2026-01-21 13:46:23', 40, 2),
(9, 5, 'Wed', '09:30:00', '11:00:00', 'Room 103', 5, '2026-01-21 13:46:23', 40, 2),
(10, 5, 'Fri', '09:30:00', '11:00:00', 'Room 103', 5, '2026-01-21 13:46:23', 40, 2),
(11, 6, 'Mon', '13:00:00', '14:30:00', 'Room 104', 6, '2026-01-21 13:46:23', 40, 2),
(12, 6, 'Wed', '13:00:00', '14:30:00', 'Room 104', 6, '2026-01-21 13:46:23', 40, 2),
(13, 7, 'Tue', '13:00:00', '14:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 2),
(14, 7, 'Thu', '13:00:00', '14:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 2),
(15, 8, 'Sat', '08:00:00', '11:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 2),
(16, 9, 'Mon', '11:00:00', '12:30:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 0),
(17, 9, 'Wed', '11:00:00', '12:30:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 0),
(18, 10, 'Tue', '08:00:00', '09:30:00', 'Lab 3', 9, '2026-01-21 13:46:23', 40, 0),
(19, 10, 'Thu', '08:00:00', '09:30:00', 'Lab 3', 9, '2026-01-21 13:46:23', 40, 0),
(20, 11, 'Mon', '09:30:00', '11:00:00', 'Lab 1', 2, '2026-01-21 13:46:23', 40, 0),
(21, 11, 'Fri', '09:30:00', '11:00:00', 'Lab 1', 2, '2026-01-21 13:46:23', 40, 0),
(22, 12, 'Tue', '09:30:00', '11:00:00', 'Lab 4', 10, '2026-01-21 13:46:23', 40, 0),
(23, 12, 'Thu', '09:30:00', '11:00:00', 'Lab 4', 10, '2026-01-21 13:46:23', 40, 0),
(24, 13, 'Wed', '09:30:00', '11:00:00', 'Room 105', 11, '2026-01-21 13:46:23', 40, 0),
(25, 13, 'Tue', '11:00:00', '12:30:00', 'Room 105', 11, '2026-01-21 13:46:23', 40, 0),
(26, 14, 'Mon', '13:00:00', '14:30:00', 'Room 104', 6, '2026-01-21 13:46:23', 40, 0),
(27, 14, 'Wed', '13:00:00', '14:30:00', 'Room 104', 6, '2026-01-21 13:46:23', 40, 0),
(28, 15, 'Tue', '13:00:00', '14:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 0),
(29, 15, 'Thu', '13:00:00', '14:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 0),
(30, 16, 'Sat', '08:00:00', '11:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 0),
(31, 17, 'Mon', '11:00:00', '12:30:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 0),
(32, 17, 'Wed', '11:00:00', '12:30:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 0),
(33, 18, 'Mon', '09:30:00', '11:00:00', 'Room 201', 12, '2026-01-21 13:46:23', 40, 0),
(34, 18, 'Thu', '09:30:00', '11:00:00', 'Room 201', 12, '2026-01-21 13:46:23', 40, 0),
(35, 19, 'Tue', '08:00:00', '09:30:00', 'Lab 1', 2, '2026-01-21 13:46:23', 40, 0),
(36, 19, 'Fri', '08:00:00', '09:30:00', 'Lab 1', 2, '2026-01-21 13:46:23', 40, 0),
(37, 20, 'Tue', '09:30:00', '11:00:00', 'Lab 3', 9, '2026-01-21 13:46:23', 40, 0),
(38, 20, 'Tue', '13:00:00', '14:30:00', 'Lab 3', 9, '2026-01-21 13:46:23', 40, 0),
(39, 21, 'Wed', '09:30:00', '11:00:00', 'Room 202', 13, '2026-01-21 13:46:23', 40, 0),
(40, 21, 'Fri', '09:30:00', '11:00:00', 'Room 202', 13, '2026-01-21 13:46:23', 40, 0),
(41, 22, 'Mon', '13:00:00', '14:30:00', 'Room 203', 14, '2026-01-21 13:46:23', 40, 0),
(42, 22, 'Wed', '13:00:00', '14:30:00', 'Room 203', 14, '2026-01-21 13:46:23', 40, 0),
(43, 23, 'Mon', '08:00:00', '09:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 0),
(44, 23, 'Fri', '13:00:00', '14:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 0),
(45, 24, 'Mon', '15:00:00', '16:30:00', 'Room 204', 47, '2026-01-21 13:46:23', 40, 0),
(46, 24, 'Wed', '15:00:00', '16:30:00', 'Room 204', 47, '2026-01-21 13:46:23', 40, 0),
(47, 25, 'Mon', '14:30:00', '16:00:00', 'Room 205', 13, '2026-01-21 13:46:23', 40, 0),
(48, 25, 'Wed', '14:30:00', '16:00:00', 'Room 205', 13, '2026-01-21 13:46:23', 40, 0),
(49, 26, 'Tue', '08:00:00', '09:30:00', 'Lab 4', 10, '2026-01-21 13:46:23', 40, 0),
(50, 26, 'Thu', '08:00:00', '09:30:00', 'Lab 4', 10, '2026-01-21 13:46:23', 40, 0),
(51, 27, 'Mon', '09:30:00', '11:00:00', 'Room 206', 14, '2026-01-21 13:46:23', 40, 0),
(52, 27, 'Fri', '09:30:00', '11:00:00', 'Room 206', 14, '2026-01-21 13:46:23', 40, 0),
(53, 28, 'Tue', '09:30:00', '11:00:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 0),
(54, 28, 'Thu', '09:30:00', '11:00:00', 'Lab 2', 3, '2026-01-21 13:46:23', 40, 0),
(55, 29, 'Wed', '09:30:00', '11:00:00', 'Lab 3', 9, '2026-01-21 13:46:23', 40, 0),
(56, 29, 'Tue', '11:00:00', '12:30:00', 'Lab 3', 9, '2026-01-21 13:46:23', 40, 0),
(57, 30, 'Mon', '13:00:00', '14:30:00', 'Room 207', 47, '2026-01-21 13:46:23', 40, 0),
(58, 30, 'Wed', '13:00:00', '14:30:00', 'Room 207', 47, '2026-01-21 13:46:23', 40, 0),
(59, 31, 'Mon', '08:00:00', '09:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 0),
(60, 31, 'Mon', '11:00:00', '12:30:00', 'Gym', 7, '2026-01-21 13:46:23', 40, 0),
(61, 32, 'Mon', '16:00:00', '17:30:00', 'Room 208', 11, '2026-01-21 13:46:23', 40, 0),
(62, 32, 'Tue', '13:00:00', '14:30:00', 'Room 208', 11, '2026-01-21 13:46:23', 40, 0),
(63, 33, 'Mon', '11:00:00', '12:30:00', 'Lab 5', 2, '2026-01-21 13:46:23', 40, 1),
(64, 33, 'Wed', '11:00:00', '12:30:00', 'Lab 5', 2, '2026-01-21 13:46:23', 40, 1),
(65, 34, 'Mon', '08:00:00', '09:30:00', 'Room 209', 12, '2026-01-21 13:46:23', 40, 1),
(66, 34, 'Mon', '14:30:00', '16:00:00', 'Room 209', 12, '2026-01-21 13:46:23', 40, 1),
(67, 35, 'Tue', '08:00:00', '09:30:00', 'Lab 6', 1, '2026-01-21 13:46:23', 40, 1),
(68, 35, 'Fri', '08:00:00', '09:30:00', 'Lab 6', 1, '2026-01-21 13:46:23', 40, 1),
(69, 36, 'Tue', '09:30:00', '11:00:00', 'Lab 7', 5, '2026-01-21 13:46:23', 40, 1),
(70, 36, 'Thu', '09:30:00', '11:00:00', 'Lab 7', 5, '2026-01-21 13:46:23', 40, 1),
(71, 37, 'Wed', '09:30:00', '11:00:00', 'Room 210', 6, '2026-01-21 13:46:23', 40, 1),
(72, 37, 'Fri', '09:30:00', '11:00:00', 'Room 210', 6, '2026-01-21 13:46:23', 40, 1),
(73, 38, 'Mon', '13:00:00', '14:30:00', 'Room 211', 4, '2026-01-21 13:46:23', 40, 1),
(74, 39, 'Fri', '13:00:00', '14:30:00', 'Room 212', 13, '2026-01-21 13:46:23', 40, 1),
(75, 40, 'Mon', '09:30:00', '11:00:00', 'Room 213', 14, '2026-01-21 13:46:23', 40, 1),
(76, 41, 'Mon', '11:00:00', '12:30:00', 'Room 214', 47, '2026-01-21 13:46:23', 40, 0),
(77, 41, 'Wed', '11:00:00', '12:30:00', 'Room 214', 47, '2026-01-21 13:46:23', 40, 0),
(78, 42, 'Tue', '08:00:00', '09:30:00', 'Room 215', 11, '2026-01-21 13:46:23', 40, 0),
(79, 42, 'Thu', '08:00:00', '09:30:00', 'Room 215', 11, '2026-01-21 13:46:23', 40, 0),
(80, 43, 'Mon', '09:30:00', '11:00:00', 'Room 216', 10, '2026-01-21 13:46:23', 40, 0),
(81, 43, 'Fri', '09:30:00', '11:00:00', 'Room 216', 10, '2026-01-21 13:46:23', 40, 0),
(82, 44, 'Tue', '09:30:00', '11:00:00', 'Room 217', 9, '2026-01-21 13:46:23', 40, 0),
(83, 44, 'Thu', '09:30:00', '11:00:00', 'Room 217', 9, '2026-01-21 13:46:23', 40, 0),
(84, 45, 'Wed', '09:30:00', '11:00:00', 'Room 218', 2, '2026-01-21 13:46:23', 40, 0),
(85, 45, 'Mon', '08:00:00', '09:30:00', 'Room 218', 2, '2026-01-21 13:46:23', 40, 0),
(86, 46, 'Mon', '13:00:00', '14:30:00', 'Room 219', 12, '2026-01-21 13:46:23', 40, 0),
(87, 47, 'Fri', '13:00:00', '14:30:00', 'Room 220', 1, '2026-01-21 13:46:23', 40, 0),
(88, 48, 'Wed', '13:00:00', '14:30:00', 'Room 221', 5, '2026-01-21 13:46:23', 40, 0),
(89, 49, 'Mon', '08:00:00', '11:00:00', 'Room 222', 6, '2026-01-21 13:46:23', 40, 0),
(90, 50, 'Tue', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 0),
(91, 50, 'Thu', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 0),
(92, 51, 'Wed', '08:00:00', '09:30:00', 'Room 223', 4, '2026-01-21 13:46:23', 40, 0),
(93, 52, 'Mon', '11:00:00', '12:30:00', 'Room 224', 13, '2026-01-21 13:46:23', 40, 0),
(94, 53, 'Mon', '14:30:00', '16:00:00', 'Room 225', 14, '2026-01-21 13:46:23', 40, 0),
(95, 54, 'Fri', '08:00:00', '09:30:00', 'Room 226', 47, '2026-01-21 13:46:23', 40, 0),
(96, 55, 'Fri', '09:30:00', '11:00:00', 'Room 227', 11, '2026-01-21 13:46:23', 40, 0),
(97, 56, 'Fri', '13:00:00', '14:30:00', 'Room 228', 10, '2026-01-21 13:46:23', 40, 0),
(98, 57, 'Mon', '08:00:00', '11:00:00', 'Room 222', 6, '2026-01-21 13:46:23', 40, 1),
(99, 58, 'Mon', '13:00:00', '14:30:00', 'Room 229', 9, '2026-01-21 13:46:23', 40, 1),
(100, 59, 'Tue', '08:00:00', '09:30:00', 'Room 230', 2, '2026-01-21 13:46:23', 40, 1),
(101, 60, 'Tue', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 1),
(102, 61, 'Wed', '08:00:00', '09:30:00', 'Room 231', 12, '2026-01-21 13:46:23', 40, 1),
(103, 62, 'Wed', '09:30:00', '11:00:00', 'Room 232', 1, '2026-01-21 13:46:23', 40, 1),
(104, 63, 'Thu', '08:00:00', '09:30:00', 'Room 233', 5, '2026-01-21 13:46:23', 40, 1),
(105, 64, 'Thu', '09:30:00', '11:00:00', 'Room 234', 6, '2026-01-21 13:46:23', 40, 1),
(106, 65, 'Mon', '10:00:00', '11:30:00', 'Room 301', 21, '2026-01-21 13:46:23', 40, 4),
(107, 65, 'Wed', '10:00:00', '11:30:00', 'Room 301', 21, '2026-01-21 13:46:23', 40, 4),
(108, 66, 'Tue', '10:00:00', '11:30:00', 'Lab 5', 65, '2026-01-21 13:46:23', 40, 4),
(109, 66, 'Thu', '10:00:00', '11:30:00', 'Lab 5', 65, '2026-01-21 13:46:23', 40, 4),
(110, 67, 'Mon', '13:00:00', '14:30:00', 'Room 302', 28, '2026-01-21 13:46:23', 40, 4),
(111, 67, 'Fri', '13:00:00', '14:30:00', 'Room 302', 28, '2026-01-21 13:46:23', 40, 4),
(112, 68, 'Tue', '13:00:00', '14:30:00', 'Lab 6', 22, '2026-01-21 13:46:23', 40, 4),
(113, 68, 'Thu', '13:00:00', '14:30:00', 'Lab 6', 22, '2026-01-21 13:46:23', 40, 4),
(114, 69, 'Wed', '13:00:00', '14:30:00', 'Room 303', 23, '2026-01-21 13:46:23', 40, 4),
(115, 69, 'Mon', '14:30:00', '16:00:00', 'Room 303', 23, '2026-01-21 13:46:23', 40, 4),
(116, 70, 'Mon', '08:00:00', '09:30:00', 'Room 304', 24, '2026-01-21 13:46:23', 40, 4),
(117, 70, 'Wed', '08:00:00', '09:30:00', 'Room 304', 24, '2026-01-21 13:46:23', 40, 4),
(118, 71, 'Tue', '08:00:00', '09:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 4),
(119, 71, 'Thu', '08:00:00', '09:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 4),
(120, 72, 'Fri', '08:00:00', '11:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 4),
(121, 73, 'Mon', '10:00:00', '11:30:00', 'Lab 5', 65, '2026-01-21 13:46:23', 40, 1),
(122, 73, 'Wed', '10:00:00', '11:30:00', 'Lab 5', 65, '2026-01-21 13:46:23', 40, 1),
(123, 74, 'Tue', '10:00:00', '11:30:00', 'Lab 6', 22, '2026-01-21 13:46:23', 40, 1),
(124, 74, 'Thu', '10:00:00', '11:30:00', 'Lab 6', 22, '2026-01-21 13:46:23', 40, 1),
(125, 75, 'Mon', '13:00:00', '14:30:00', 'Room 305', 27, '2026-01-21 13:46:23', 40, 1),
(126, 75, 'Fri', '13:00:00', '14:30:00', 'Room 305', 27, '2026-01-21 13:46:23', 40, 1),
(127, 76, 'Tue', '13:00:00', '14:30:00', 'Lab 7', 26, '2026-01-21 13:46:23', 40, 1),
(128, 76, 'Thu', '13:00:00', '14:30:00', 'Lab 7', 26, '2026-01-21 13:46:23', 40, 1),
(129, 77, 'Wed', '13:00:00', '14:30:00', 'Room 306', 25, '2026-01-21 13:46:23', 40, 1),
(130, 77, 'Mon', '14:30:00', '16:00:00', 'Room 306', 25, '2026-01-21 13:46:23', 40, 1),
(131, 78, 'Mon', '08:00:00', '09:30:00', 'Room 304', 24, '2026-01-21 13:46:23', 40, 1),
(132, 78, 'Wed', '08:00:00', '09:30:00', 'Room 304', 24, '2026-01-21 13:46:23', 40, 1),
(133, 79, 'Tue', '08:00:00', '09:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 1),
(134, 79, 'Thu', '08:00:00', '09:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 1),
(135, 80, 'Fri', '08:00:00', '11:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 1),
(136, 81, 'Mon', '11:00:00', '12:30:00', 'Lab 8', 65, '2026-01-21 13:46:23', 40, 1),
(137, 81, 'Wed', '11:00:00', '12:30:00', 'Lab 8', 65, '2026-01-21 13:46:23', 40, 1),
(138, 82, 'Mon', '08:00:00', '09:30:00', 'Room 307', 21, '2026-01-21 13:46:23', 40, 1),
(139, 82, 'Thu', '09:30:00', '11:00:00', 'Room 307', 21, '2026-01-21 13:46:23', 40, 1),
(140, 83, 'Tue', '08:00:00', '09:30:00', 'Room 308', 28, '2026-01-21 13:46:23', 40, 1),
(141, 83, 'Fri', '08:00:00', '09:30:00', 'Room 308', 28, '2026-01-21 13:46:23', 40, 1),
(142, 84, 'Tue', '09:30:00', '11:00:00', 'Lab 9', 22, '2026-01-21 13:46:23', 40, 1),
(143, 84, 'Tue', '11:00:00', '12:30:00', 'Lab 9', 22, '2026-01-21 13:46:23', 40, 1),
(144, 85, 'Wed', '09:30:00', '11:00:00', 'Room 309', 23, '2026-01-21 13:46:23', 40, 1),
(145, 85, 'Fri', '09:30:00', '11:00:00', 'Room 309', 23, '2026-01-21 13:46:23', 40, 1),
(146, 86, 'Mon', '13:00:00', '14:30:00', 'Room 310', 27, '2026-01-21 13:46:23', 40, 1),
(147, 86, 'Wed', '13:00:00', '14:30:00', 'Room 310', 27, '2026-01-21 13:46:23', 40, 1),
(148, 87, 'Tue', '13:00:00', '14:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 1),
(149, 87, 'Fri', '13:00:00', '14:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 1),
(150, 88, 'Mon', '15:00:00', '16:30:00', 'Room 311', 24, '2026-01-21 13:46:23', 40, 1),
(151, 88, 'Wed', '15:00:00', '16:30:00', 'Room 311', 24, '2026-01-21 13:46:23', 40, 1),
(152, 89, 'Mon', '14:30:00', '16:00:00', 'Room 312', 26, '2026-01-21 13:46:23', 40, 0),
(153, 89, 'Wed', '14:30:00', '16:00:00', 'Room 312', 26, '2026-01-21 13:46:23', 40, 0),
(154, 90, 'Tue', '08:00:00', '09:30:00', 'Lab 10', 25, '2026-01-21 13:46:23', 40, 0),
(155, 90, 'Thu', '08:00:00', '09:30:00', 'Lab 10', 25, '2026-01-21 13:46:23', 40, 0),
(156, 91, 'Mon', '09:30:00', '11:00:00', 'Room 313', 21, '2026-01-21 13:46:23', 40, 0),
(157, 91, 'Fri', '09:30:00', '11:00:00', 'Room 313', 21, '2026-01-21 13:46:23', 40, 0),
(158, 92, 'Tue', '09:30:00', '11:00:00', 'Room 314', 65, '2026-01-21 13:46:23', 40, 0),
(159, 92, 'Thu', '09:30:00', '11:00:00', 'Room 314', 65, '2026-01-21 13:46:23', 40, 0),
(160, 93, 'Wed', '09:30:00', '11:00:00', 'Lab 11', 28, '2026-01-21 13:46:23', 40, 0),
(161, 93, 'Mon', '08:00:00', '09:30:00', 'Lab 11', 28, '2026-01-21 13:46:23', 40, 0),
(162, 94, 'Mon', '13:00:00', '14:30:00', 'Room 315', 22, '2026-01-21 13:46:23', 40, 0),
(163, 94, 'Wed', '13:00:00', '14:30:00', 'Room 315', 22, '2026-01-21 13:46:23', 40, 0),
(164, 95, 'Tue', '13:00:00', '14:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 0),
(165, 95, 'Thu', '13:00:00', '14:30:00', 'Gym', 43, '2026-01-21 13:46:23', 40, 0),
(166, 96, 'Mon', '16:00:00', '17:30:00', 'Room 316', 23, '2026-01-21 13:46:23', 40, 0),
(167, 96, 'Tue', '11:00:00', '12:30:00', 'Room 316', 23, '2026-01-21 13:46:23', 40, 0),
(168, 97, 'Mon', '14:30:00', '16:00:00', 'Lab 12', 27, '2026-01-21 13:46:23', 40, 0),
(169, 97, 'Wed', '14:30:00', '16:00:00', 'Lab 12', 27, '2026-01-21 13:46:23', 40, 0),
(170, 98, 'Mon', '09:30:00', '11:00:00', 'Lab 13', 26, '2026-01-21 13:46:23', 40, 0),
(171, 98, 'Thu', '09:30:00', '11:00:00', 'Lab 13', 26, '2026-01-21 13:46:23', 40, 0),
(172, 99, 'Tue', '08:00:00', '09:30:00', 'Room 317', 25, '2026-01-21 13:46:23', 40, 0),
(173, 99, 'Fri', '08:00:00', '09:30:00', 'Room 317', 25, '2026-01-21 13:46:23', 40, 0),
(174, 100, 'Tue', '09:30:00', '11:00:00', 'Lab 14', 24, '2026-01-21 13:46:23', 40, 0),
(175, 100, 'Mon', '11:00:00', '12:30:00', 'Lab 14', 24, '2026-01-21 13:46:23', 40, 0),
(176, 101, 'Mon', '16:00:00', '17:30:00', 'Lab 15', 21, '2026-01-21 13:46:23', 40, 0),
(177, 101, 'Fri', '09:30:00', '11:00:00', 'Lab 15', 21, '2026-01-21 13:46:23', 40, 0),
(178, 102, 'Mon', '13:00:00', '14:30:00', 'Room 318', 65, '2026-01-21 13:46:23', 40, 0),
(179, 103, 'Mon', '08:00:00', '09:30:00', 'Room 319', 28, '2026-01-21 13:46:23', 40, 0),
(180, 104, 'Wed', '13:00:00', '14:30:00', 'Room 320', 22, '2026-01-21 13:46:23', 40, 0),
(181, 105, 'Mon', '08:00:00', '09:30:00', 'Room 321', 23, '2026-01-21 13:46:23', 40, 0),
(182, 105, 'Wed', '08:00:00', '09:30:00', 'Room 321', 23, '2026-01-21 13:46:23', 40, 0),
(183, 106, 'Tue', '08:00:00', '09:30:00', 'Room 322', 27, '2026-01-21 13:46:23', 40, 0),
(184, 106, 'Thu', '08:00:00', '09:30:00', 'Room 322', 27, '2026-01-21 13:46:23', 40, 0),
(185, 107, 'Mon', '09:30:00', '11:00:00', 'Room 323', 26, '2026-01-21 13:46:23', 40, 0),
(186, 107, 'Fri', '09:30:00', '11:00:00', 'Room 323', 26, '2026-01-21 13:46:23', 40, 0),
(187, 108, 'Tue', '09:30:00', '11:00:00', 'Room 324', 25, '2026-01-21 13:46:23', 40, 0),
(188, 108, 'Thu', '09:30:00', '11:00:00', 'Room 324', 25, '2026-01-21 13:46:23', 40, 0),
(189, 109, 'Wed', '09:30:00', '11:00:00', 'Room 325', 24, '2026-01-21 13:46:23', 40, 0),
(190, 109, 'Mon', '11:00:00', '12:30:00', 'Room 325', 24, '2026-01-21 13:46:23', 40, 0),
(191, 110, 'Mon', '13:00:00', '14:30:00', 'Lab 16', 21, '2026-01-21 13:46:23', 40, 0),
(192, 111, 'Fri', '13:00:00', '14:30:00', 'Room 326', 65, '2026-01-21 13:46:23', 40, 0),
(193, 112, 'Wed', '13:00:00', '14:30:00', 'Room 327', 28, '2026-01-21 13:46:23', 40, 0),
(194, 113, 'Mon', '08:00:00', '11:00:00', 'Room 328', 22, '2026-01-21 13:46:23', 40, 1),
(195, 114, 'Tue', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 1),
(196, 114, 'Thu', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 1),
(197, 115, 'Wed', '08:00:00', '09:30:00', 'Room 329', 23, '2026-01-21 13:46:23', 40, 1),
(198, 116, 'Wed', '09:30:00', '11:00:00', 'Lab 17', 27, '2026-01-21 13:46:23', 40, 1),
(199, 117, 'Mon', '13:00:00', '14:30:00', 'Room 330', 26, '2026-01-21 13:46:23', 40, 1),
(200, 118, 'Mon', '11:00:00', '12:30:00', 'Room 331', 25, '2026-01-21 13:46:23', 40, 1),
(201, 119, 'Fri', '09:30:00', '11:00:00', 'Room 332', 24, '2026-01-21 13:46:23', 40, 1),
(202, 120, 'Fri', '13:00:00', '14:30:00', 'Room 333', 21, '2026-01-21 13:46:23', 40, 1),
(203, 121, 'Mon', '08:00:00', '11:00:00', 'Room 328', 22, '2026-01-21 13:46:23', 40, 0),
(204, 122, 'Mon', '13:00:00', '14:30:00', 'Room 334', 65, '2026-01-21 13:46:23', 40, 0),
(205, 123, 'Tue', '08:00:00', '09:30:00', 'Room 335', 28, '2026-01-21 13:46:23', 40, 0),
(206, 124, 'Tue', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(207, 125, 'Mon', '11:00:00', '12:30:00', 'Room 336', 23, '2026-01-21 13:46:23', 40, 0),
(208, 126, 'Wed', '09:30:00', '11:00:00', 'Room 337', 27, '2026-01-21 13:46:23', 40, 0),
(209, 127, 'Thu', '08:00:00', '09:30:00', 'Room 338', 26, '2026-01-21 13:46:23', 40, 0),
(210, 128, 'Mon', '16:00:00', '17:30:00', 'Room 339', 25, '2026-01-21 13:46:23', 40, 0),
(211, 193, 'Mon', '11:00:00', '12:30:00', 'Room 401', 20, '2026-01-21 13:46:23', 40, 1),
(212, 193, 'Wed', '11:00:00', '12:30:00', 'Room 401', 20, '2026-01-21 13:46:23', 40, 1),
(213, 194, 'Mon', '09:30:00', '11:00:00', 'Room 402', 38, '2026-01-21 13:46:23', 40, 1),
(214, 194, 'Thu', '09:30:00', '11:00:00', 'Room 402', 38, '2026-01-21 13:46:23', 40, 1),
(215, 195, 'Tue', '08:00:00', '09:30:00', 'Room 403', 59, '2026-01-21 13:46:23', 40, 1),
(216, 195, 'Fri', '08:00:00', '09:30:00', 'Room 403', 59, '2026-01-21 13:46:23', 40, 1),
(217, 196, 'Tue', '09:30:00', '11:00:00', 'Room 404', 18, '2026-01-21 13:46:23', 40, 1),
(218, 196, 'Mon', '08:00:00', '09:30:00', 'Room 404', 18, '2026-01-21 13:46:23', 40, 1),
(219, 197, 'Wed', '09:30:00', '11:00:00', 'Room 405', 45, '2026-01-21 13:46:23', 40, 1),
(220, 197, 'Fri', '09:30:00', '11:00:00', 'Room 405', 45, '2026-01-21 13:46:23', 40, 1),
(221, 198, 'Mon', '13:00:00', '14:30:00', 'Room 406', 17, '2026-01-21 13:46:23', 40, 1),
(222, 198, 'Wed', '13:00:00', '14:30:00', 'Room 406', 17, '2026-01-21 13:46:23', 40, 1),
(223, 199, 'Tue', '13:00:00', '14:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 1),
(224, 199, 'Thu', '13:00:00', '14:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 1),
(225, 200, 'Sat', '13:00:00', '16:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 1),
(226, 201, 'Mon', '14:30:00', '16:00:00', 'Room 401', 20, '2026-01-21 13:46:23', 40, 1),
(227, 201, 'Wed', '14:30:00', '16:00:00', 'Room 401', 20, '2026-01-21 13:46:23', 40, 1),
(228, 202, 'Tue', '08:00:00', '09:30:00', 'Room 407', 67, '2026-01-21 13:46:23', 40, 1),
(229, 202, 'Thu', '08:00:00', '09:30:00', 'Room 407', 67, '2026-01-21 13:46:23', 40, 1),
(230, 203, 'Mon', '09:30:00', '11:00:00', 'Room 408', 63, '2026-01-21 13:46:23', 40, 1),
(231, 203, 'Fri', '09:30:00', '11:00:00', 'Room 408', 63, '2026-01-21 13:46:23', 40, 1),
(232, 204, 'Tue', '09:30:00', '11:00:00', 'Room 409', 51, '2026-01-21 13:46:23', 40, 1),
(233, 204, 'Thu', '09:30:00', '11:00:00', 'Room 409', 51, '2026-01-21 13:46:23', 40, 1),
(234, 205, 'Wed', '09:30:00', '11:00:00', 'Room 410', 70, '2026-01-21 13:46:23', 40, 1),
(235, 205, 'Mon', '08:00:00', '09:30:00', 'Room 410', 70, '2026-01-21 13:46:23', 40, 1),
(236, 206, 'Mon', '13:00:00', '14:30:00', 'Room 406', 17, '2026-01-21 13:46:23', 40, 1),
(237, 206, 'Wed', '13:00:00', '14:30:00', 'Room 406', 17, '2026-01-21 13:46:23', 40, 1),
(238, 207, 'Tue', '13:00:00', '14:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 1),
(239, 207, 'Thu', '13:00:00', '14:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 1),
(240, 208, 'Fri', '13:00:00', '16:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 1),
(241, 209, 'Mon', '11:00:00', '12:30:00', 'Room 411', 52, '2026-01-21 13:46:23', 40, 1),
(242, 209, 'Wed', '11:00:00', '12:30:00', 'Room 411', 52, '2026-01-21 13:46:23', 40, 1),
(243, 210, 'Mon', '09:30:00', '11:00:00', 'Room 412', 58, '2026-01-21 13:46:23', 40, 1),
(244, 210, 'Thu', '09:30:00', '11:00:00', 'Room 412', 58, '2026-01-21 13:46:23', 40, 1),
(245, 211, 'Tue', '08:00:00', '09:30:00', 'Room 413', 66, '2026-01-21 13:46:23', 40, 1),
(246, 211, 'Fri', '08:00:00', '09:30:00', 'Room 413', 66, '2026-01-21 13:46:23', 40, 1),
(247, 212, 'Mon', '08:00:00', '09:30:00', 'Room 414', 9, '2026-01-21 13:46:23', 40, 1),
(248, 212, 'Tue', '11:00:00', '12:30:00', 'Room 414', 9, '2026-01-21 13:46:23', 40, 1),
(249, 213, 'Wed', '09:30:00', '11:00:00', 'Room 415', 48, '2026-01-21 13:46:23', 40, 1),
(250, 213, 'Fri', '09:30:00', '11:00:00', 'Room 415', 48, '2026-01-21 13:46:23', 40, 1),
(251, 214, 'Mon', '13:00:00', '14:30:00', 'Room 416', 60, '2026-01-21 13:46:23', 40, 1),
(252, 214, 'Wed', '13:00:00', '14:30:00', 'Room 416', 60, '2026-01-21 13:46:23', 40, 1),
(253, 215, 'Tue', '09:30:00', '11:00:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 1),
(254, 215, 'Fri', '13:00:00', '14:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 1),
(255, 216, 'Mon', '15:00:00', '16:30:00', 'Room 417', 55, '2026-01-21 13:46:23', 40, 1),
(256, 216, 'Wed', '15:00:00', '16:30:00', 'Room 417', 55, '2026-01-21 13:46:23', 40, 1),
(257, 217, 'Mon', '14:30:00', '16:00:00', 'Room 418', 37, '2026-01-21 13:46:23', 40, 0),
(258, 217, 'Wed', '14:30:00', '16:00:00', 'Room 418', 37, '2026-01-21 13:46:23', 40, 0),
(259, 218, 'Tue', '08:00:00', '09:30:00', 'Room 419', 13, '2026-01-21 13:46:23', 40, 0),
(260, 218, 'Thu', '08:00:00', '09:30:00', 'Room 419', 13, '2026-01-21 13:46:23', 40, 0),
(261, 219, 'Mon', '09:30:00', '11:00:00', 'Room 420', 32, '2026-01-21 13:46:23', 40, 0),
(262, 219, 'Fri', '09:30:00', '11:00:00', 'Room 420', 32, '2026-01-21 13:46:23', 40, 0),
(263, 220, 'Tue', '09:30:00', '11:00:00', 'Lab 7', 31, '2026-01-21 13:46:23', 40, 0),
(264, 220, 'Thu', '09:30:00', '11:00:00', 'Lab 7', 31, '2026-01-21 13:46:23', 40, 0),
(265, 221, 'Wed', '09:30:00', '11:00:00', 'Room 421', 10, '2026-01-21 13:46:23', 40, 0),
(266, 221, 'Mon', '08:00:00', '09:30:00', 'Room 421', 10, '2026-01-21 13:46:23', 40, 0),
(267, 222, 'Mon', '13:00:00', '14:30:00', 'Room 422', 15, '2026-01-21 13:46:23', 40, 0),
(268, 222, 'Wed', '13:00:00', '14:30:00', 'Room 422', 15, '2026-01-21 13:46:23', 40, 0),
(269, 223, 'Mon', '16:00:00', '17:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 0),
(270, 223, 'Mon', '11:00:00', '12:30:00', 'Gym', 44, '2026-01-21 13:46:23', 40, 0),
(271, 224, 'Tue', '14:30:00', '16:00:00', 'Room 423', 11, '2026-01-21 13:46:23', 40, 0),
(272, 224, 'Tue', '16:00:00', '17:30:00', 'Room 423', 11, '2026-01-21 13:46:23', 40, 0),
(273, 225, 'Mon', '11:00:00', '12:30:00', 'Room 424', 45, '2026-01-21 13:46:23', 40, 0),
(274, 225, 'Wed', '11:00:00', '12:30:00', 'Room 424', 45, '2026-01-21 13:46:23', 40, 0),
(275, 226, 'Mon', '09:30:00', '11:00:00', 'Room 425', 3, '2026-01-21 13:46:23', 40, 0),
(276, 226, 'Thu', '09:30:00', '11:00:00', 'Room 425', 3, '2026-01-21 13:46:23', 40, 0),
(277, 227, 'Mon', '08:00:00', '09:30:00', 'Room 426', 2, '2026-01-21 13:46:23', 40, 0),
(278, 227, 'Tue', '09:30:00', '11:00:00', 'Room 426', 2, '2026-01-21 13:46:23', 40, 0),
(279, 228, 'Tue', '14:30:00', '16:00:00', 'Room 427', 4, '2026-01-21 13:46:23', 40, 0),
(280, 228, 'Tue', '11:00:00', '12:30:00', 'Room 427', 4, '2026-01-21 13:46:23', 40, 0),
(281, 229, 'Wed', '09:30:00', '11:00:00', 'Room 428', 1, '2026-01-21 13:46:23', 40, 0),
(282, 229, 'Fri', '09:30:00', '11:00:00', 'Room 428', 1, '2026-01-21 13:46:23', 40, 0),
(283, 230, 'Mon', '13:00:00', '14:30:00', 'Room 429', 54, '2026-01-21 13:46:23', 40, 0),
(284, 230, 'Wed', '13:00:00', '14:30:00', 'Room 429', 54, '2026-01-21 13:46:23', 40, 0),
(285, 231, 'Fri', '13:00:00', '14:30:00', 'Room 430', 33, '2026-01-21 13:46:23', 40, 0),
(286, 231, 'Tue', '13:00:00', '14:30:00', 'Room 430', 33, '2026-01-21 13:46:23', 40, 0),
(287, 232, 'Tue', '08:00:00', '09:30:00', 'Room 431', 34, '2026-01-21 13:46:23', 40, 0),
(288, 232, 'Mon', '15:00:00', '16:30:00', 'Room 431', 34, '2026-01-21 13:46:23', 40, 0),
(289, 233, 'Mon', '14:30:00', '16:00:00', 'Room 432', 29, '2026-01-21 13:46:23', 40, 0),
(290, 233, 'Wed', '14:30:00', '16:00:00', 'Room 432', 29, '2026-01-21 13:46:23', 40, 0),
(291, 234, 'Tue', '08:00:00', '09:30:00', 'Room 433', 16, '2026-01-21 13:46:23', 40, 0),
(292, 234, 'Thu', '08:00:00', '09:30:00', 'Room 433', 16, '2026-01-21 13:46:23', 40, 0),
(293, 235, 'Mon', '09:30:00', '11:00:00', 'Room 434', 35, '2026-01-21 13:46:23', 40, 0),
(294, 235, 'Fri', '09:30:00', '11:00:00', 'Room 434', 35, '2026-01-21 13:46:23', 40, 0),
(295, 236, 'Tue', '09:30:00', '11:00:00', 'Room 435', 40, '2026-01-21 13:46:23', 40, 0),
(296, 236, 'Thu', '09:30:00', '11:00:00', 'Room 435', 40, '2026-01-21 13:46:23', 40, 0),
(297, 237, 'Wed', '09:30:00', '11:00:00', 'Room 436', 46, '2026-01-21 13:46:23', 40, 0),
(298, 237, 'Mon', '08:00:00', '09:30:00', 'Room 436', 46, '2026-01-21 13:46:23', 40, 0),
(299, 238, 'Mon', '13:00:00', '14:30:00', 'Room 437', 61, '2026-01-21 13:46:23', 40, 0),
(300, 238, 'Wed', '13:00:00', '14:30:00', 'Room 437', 61, '2026-01-21 13:46:23', 40, 0),
(301, 239, 'Fri', '13:00:00', '14:30:00', 'Room 438', 19, '2026-01-21 13:46:23', 40, 0),
(302, 239, 'Tue', '13:00:00', '14:30:00', 'Room 438', 19, '2026-01-21 13:46:23', 40, 0),
(303, 240, 'Mon', '16:00:00', '17:30:00', 'Room 439', 68, '2026-01-21 13:46:23', 40, 0),
(304, 240, 'Mon', '11:00:00', '12:30:00', 'Room 439', 68, '2026-01-21 13:46:23', 40, 0),
(305, 241, 'Mon', '08:00:00', '11:00:00', 'Room 440', 5, '2026-01-21 13:46:23', 40, 1),
(306, 242, 'Tue', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 1),
(307, 242, 'Thu', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 1),
(308, 243, 'Wed', '08:00:00', '09:30:00', 'Room 441', 6, '2026-01-21 13:46:23', 40, 1),
(309, 243, 'Mon', '11:00:00', '12:30:00', 'Room 441', 6, '2026-01-21 13:46:23', 40, 1),
(310, 244, 'Wed', '09:30:00', '11:00:00', 'Room 442', 18, '2026-01-21 13:46:23', 40, 1),
(311, 244, 'Mon', '15:00:00', '16:30:00', 'Room 442', 18, '2026-01-21 13:46:23', 40, 1),
(312, 245, 'Mon', '13:00:00', '14:30:00', 'Room 443', 2, '2026-01-21 13:46:23', 40, 1),
(313, 245, 'Wed', '13:00:00', '14:30:00', 'Room 443', 2, '2026-01-21 13:46:23', 40, 1),
(314, 246, 'Fri', '08:00:00', '09:30:00', 'Room 444', 4, '2026-01-21 13:46:23', 40, 1),
(315, 246, 'Wed', '11:00:00', '12:30:00', 'Room 444', 4, '2026-01-21 13:46:23', 40, 1),
(316, 247, 'Fri', '09:30:00', '11:00:00', 'Room 445', 3, '2026-01-21 13:46:23', 40, 1),
(317, 247, 'Wed', '14:30:00', '16:00:00', 'Room 445', 3, '2026-01-21 13:46:23', 40, 1),
(318, 248, 'Fri', '13:00:00', '14:30:00', 'Room 446', 1, '2026-01-21 13:46:23', 40, 1),
(319, 248, 'Wed', '16:00:00', '17:30:00', 'Room 446', 1, '2026-01-21 13:46:23', 40, 1),
(320, 249, 'Mon', '08:00:00', '11:00:00', 'Room 440', 5, '2026-01-21 13:46:23', 40, 0),
(321, 250, 'Mon', '13:00:00', '14:30:00', 'Room 447', 38, '2026-01-21 13:46:23', 40, 0),
(322, 250, 'Wed', '13:00:00', '14:30:00', 'Room 447', 38, '2026-01-21 13:46:23', 40, 0),
(323, 251, 'Tue', '08:00:00', '09:30:00', 'Room 448', 45, '2026-01-21 13:46:23', 40, 0),
(324, 251, 'Thu', '08:00:00', '09:30:00', 'Room 448', 45, '2026-01-21 13:46:23', 40, 0),
(325, 252, 'Tue', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(326, 252, 'Thu', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(327, 253, 'Wed', '08:00:00', '09:30:00', 'Room 449', 59, '2026-01-21 13:46:23', 40, 0),
(328, 253, 'Fri', '08:00:00', '09:30:00', 'Room 449', 59, '2026-01-21 13:46:23', 40, 0),
(329, 254, 'Wed', '09:30:00', '11:00:00', 'Room 450', 20, '2026-01-21 13:46:23', 40, 0),
(330, 254, 'Fri', '09:30:00', '11:00:00', 'Room 450', 20, '2026-01-21 13:46:23', 40, 0),
(331, 255, 'Mon', '11:00:00', '12:30:00', 'Room 451', 67, '2026-01-21 13:46:23', 40, 0),
(332, 255, 'Tue', '13:00:00', '14:30:00', 'Room 451', 67, '2026-01-21 13:46:23', 40, 0),
(333, 256, 'Mon', '14:30:00', '16:00:00', 'Room 452', 63, '2026-01-21 13:46:23', 40, 0),
(334, 256, 'Tue', '15:00:00', '16:30:00', 'Room 452', 63, '2026-01-21 13:46:23', 40, 0),
(335, 129, 'Mon', '08:00:00', '09:30:00', 'Room 501', 60, '2026-01-21 13:46:23', 40, 1),
(336, 129, 'Wed', '08:00:00', '09:30:00', 'Room 501', 60, '2026-01-21 13:46:23', 40, 1),
(337, 130, 'Mon', '09:30:00', '11:00:00', 'Room 502', 50, '2026-01-21 13:46:23', 40, 1),
(338, 130, 'Thu', '09:30:00', '11:00:00', 'Room 502', 50, '2026-01-21 13:46:23', 40, 1),
(339, 131, 'Tue', '08:00:00', '09:30:00', 'Lab 20', 57, '2026-01-21 13:46:23', 40, 1),
(340, 131, 'Fri', '08:00:00', '09:30:00', 'Lab 20', 57, '2026-01-21 13:46:23', 40, 1),
(341, 132, 'Tue', '09:30:00', '11:00:00', 'Room 503', 39, '2026-01-21 13:46:23', 40, 1),
(342, 132, 'Tue', '14:30:00', '16:00:00', 'Room 503', 39, '2026-01-21 13:46:23', 40, 1),
(343, 133, 'Wed', '09:30:00', '11:00:00', 'Room 504', 53, '2026-01-21 13:46:23', 40, 1),
(344, 133, 'Fri', '09:30:00', '11:00:00', 'Room 504', 53, '2026-01-21 13:46:23', 40, 1),
(345, 134, 'Mon', '13:00:00', '14:30:00', 'Room 505', 69, '2026-01-21 13:46:23', 40, 1),
(346, 134, 'Wed', '13:00:00', '14:30:00', 'Room 505', 69, '2026-01-21 13:46:23', 40, 1),
(347, 135, 'Tue', '13:00:00', '14:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 1),
(348, 135, 'Thu', '13:00:00', '14:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 1),
(349, 136, 'Fri', '13:00:00', '16:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 1),
(350, 137, 'Mon', '08:00:00', '09:30:00', 'Lab 21', 57, '2026-01-21 13:46:23', 40, 0),
(351, 137, 'Wed', '08:00:00', '09:30:00', 'Lab 21', 57, '2026-01-21 13:46:23', 40, 0),
(352, 138, 'Tue', '08:00:00', '09:30:00', 'Room 506', 69, '2026-01-21 13:46:23', 40, 0),
(353, 138, 'Thu', '08:00:00', '09:30:00', 'Room 506', 69, '2026-01-21 13:46:23', 40, 0),
(354, 139, 'Mon', '09:30:00', '11:00:00', 'Lab 22', 60, '2026-01-21 13:46:23', 40, 0),
(355, 139, 'Fri', '09:30:00', '11:00:00', 'Lab 22', 60, '2026-01-21 13:46:23', 40, 0),
(356, 140, 'Tue', '09:30:00', '11:00:00', 'Room 507', 50, '2026-01-21 13:46:23', 40, 0),
(357, 140, 'Thu', '09:30:00', '11:00:00', 'Room 507', 50, '2026-01-21 13:46:23', 40, 0),
(358, 141, 'Wed', '09:30:00', '11:00:00', 'Room 508', 39, '2026-01-21 13:46:23', 40, 0),
(359, 141, 'Mon', '11:00:00', '12:30:00', 'Room 508', 39, '2026-01-21 13:46:23', 40, 0),
(360, 142, 'Mon', '13:00:00', '14:30:00', 'Room 509', 53, '2026-01-21 13:46:23', 40, 0),
(361, 142, 'Wed', '13:00:00', '14:30:00', 'Room 509', 53, '2026-01-21 13:46:23', 40, 0),
(362, 143, 'Tue', '13:00:00', '14:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 0),
(363, 143, 'Thu', '13:00:00', '14:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 0),
(364, 144, 'Sat', '13:00:00', '16:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 0),
(365, 145, 'Mon', '08:00:00', '09:30:00', 'Room 510', 57, '2026-01-21 13:46:23', 40, 2),
(366, 145, 'Wed', '08:00:00', '09:30:00', 'Room 510', 57, '2026-01-21 13:46:23', 40, 2),
(367, 146, 'Mon', '09:30:00', '11:00:00', 'Room 511', 60, '2026-01-21 13:46:23', 40, 2),
(368, 146, 'Thu', '09:30:00', '11:00:00', 'Room 511', 60, '2026-01-21 13:46:23', 40, 2),
(369, 147, 'Tue', '08:00:00', '09:30:00', 'Room 512', 50, '2026-01-21 13:46:23', 40, 2),
(370, 147, 'Fri', '08:00:00', '09:30:00', 'Room 512', 50, '2026-01-21 13:46:23', 40, 2),
(371, 148, 'Mon', '11:00:00', '12:30:00', 'Lab 23', 39, '2026-01-21 13:46:23', 40, 2),
(372, 148, 'Tue', '11:00:00', '12:30:00', 'Lab 23', 39, '2026-01-21 13:46:23', 40, 2),
(373, 149, 'Tue', '09:30:00', '11:00:00', 'Room 513', 53, '2026-01-21 13:46:23', 40, 2),
(374, 149, 'Mon', '13:00:00', '14:30:00', 'Room 513', 53, '2026-01-21 13:46:23', 40, 2),
(375, 150, 'Tue', '14:30:00', '16:00:00', 'Room 514', 69, '2026-01-21 13:46:23', 40, 2),
(376, 150, 'Tue', '13:00:00', '14:30:00', 'Room 514', 69, '2026-01-21 13:46:23', 40, 2),
(377, 151, 'Tue', '16:00:00', '17:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 2),
(378, 151, 'Fri', '13:00:00', '14:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 2),
(379, 152, 'Mon', '15:00:00', '16:30:00', 'Room 515', 57, '2026-01-21 13:46:23', 40, 2),
(380, 152, 'Wed', '15:00:00', '16:30:00', 'Room 515', 57, '2026-01-21 13:46:23', 40, 2),
(381, 153, 'Mon', '14:30:00', '16:00:00', 'Lab 24', 60, '2026-01-21 13:46:23', 40, 0),
(382, 153, 'Wed', '14:30:00', '16:00:00', 'Lab 24', 60, '2026-01-21 13:46:23', 40, 0),
(383, 154, 'Tue', '08:00:00', '09:30:00', 'Lab 25', 50, '2026-01-21 13:46:23', 40, 0),
(384, 154, 'Thu', '08:00:00', '09:30:00', 'Lab 25', 50, '2026-01-21 13:46:23', 40, 0),
(385, 155, 'Mon', '09:30:00', '11:00:00', 'Room 516', 39, '2026-01-21 13:46:23', 40, 0),
(386, 155, 'Mon', '08:00:00', '09:30:00', 'Room 516', 39, '2026-01-21 13:46:23', 40, 0),
(387, 156, 'Tue', '09:30:00', '11:00:00', 'Lab 26', 53, '2026-01-21 13:46:23', 40, 0),
(388, 156, 'Thu', '09:30:00', '11:00:00', 'Lab 26', 53, '2026-01-21 13:46:23', 40, 0),
(389, 157, 'Wed', '09:30:00', '11:00:00', 'Room 517', 69, '2026-01-21 13:46:23', 40, 0),
(390, 157, 'Fri', '09:30:00', '11:00:00', 'Room 517', 69, '2026-01-21 13:46:23', 40, 0),
(391, 158, 'Mon', '13:00:00', '14:30:00', 'Room 518', 57, '2026-01-21 13:46:23', 40, 0),
(392, 158, 'Wed', '13:00:00', '14:30:00', 'Room 518', 57, '2026-01-21 13:46:23', 40, 0),
(393, 159, 'Tue', '11:00:00', '12:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 0),
(394, 159, 'Mon', '11:00:00', '12:30:00', 'Gym', 42, '2026-01-21 13:46:23', 40, 0),
(395, 160, 'Mon', '16:00:00', '17:30:00', 'Room 519', 60, '2026-01-21 13:46:23', 40, 0),
(396, 160, 'Tue', '13:00:00', '14:30:00', 'Room 519', 60, '2026-01-21 13:46:23', 40, 0),
(397, 161, 'Mon', '11:00:00', '12:30:00', 'Room 520', 50, '2026-01-21 13:46:23', 40, 0),
(398, 161, 'Wed', '11:00:00', '12:30:00', 'Room 520', 50, '2026-01-21 13:46:23', 40, 0),
(399, 162, 'Mon', '09:30:00', '11:00:00', 'Room 521', 39, '2026-01-21 13:46:23', 40, 0),
(400, 162, 'Mon', '08:00:00', '09:30:00', 'Room 521', 39, '2026-01-21 13:46:23', 40, 0),
(401, 163, 'Tue', '08:00:00', '09:30:00', 'Room 522', 53, '2026-01-21 13:46:23', 40, 0),
(402, 163, 'Fri', '08:00:00', '09:30:00', 'Room 522', 53, '2026-01-21 13:46:23', 40, 0),
(403, 164, 'Tue', '09:30:00', '11:00:00', 'Lab 27', 69, '2026-01-21 13:46:23', 40, 0),
(404, 164, 'Thu', '09:30:00', '11:00:00', 'Lab 27', 69, '2026-01-21 13:46:23', 40, 0),
(405, 165, 'Wed', '09:30:00', '11:00:00', 'Room 523', 57, '2026-01-21 13:46:23', 40, 0),
(406, 165, 'Fri', '09:30:00', '11:00:00', 'Room 523', 57, '2026-01-21 13:46:23', 40, 0),
(407, 166, 'Tue', '11:00:00', '12:30:00', 'Room 524', 60, '2026-01-21 13:46:23', 40, 0),
(408, 166, 'Tue', '14:30:00', '16:00:00', 'Room 524', 60, '2026-01-21 13:46:23', 40, 0),
(409, 167, 'Fri', '13:00:00', '14:30:00', 'Room 525', 50, '2026-01-21 13:46:23', 40, 0),
(410, 167, 'Tue', '13:00:00', '14:30:00', 'Room 525', 50, '2026-01-21 13:46:23', 40, 0),
(411, 168, 'Wed', '13:00:00', '14:30:00', 'Room 526', 39, '2026-01-21 13:46:23', 40, 0),
(412, 168, 'Mon', '15:00:00', '16:30:00', 'Room 526', 39, '2026-01-21 13:46:23', 40, 0),
(413, 169, 'Mon', '14:30:00', '16:00:00', 'Room 527', 53, '2026-01-21 13:46:23', 40, 0),
(414, 169, 'Wed', '14:30:00', '16:00:00', 'Room 527', 53, '2026-01-21 13:46:23', 40, 0),
(415, 170, 'Mon', '08:00:00', '09:30:00', 'Room 528', 69, '2026-01-21 13:46:23', 40, 0),
(416, 170, 'Tue', '11:00:00', '12:30:00', 'Room 528', 69, '2026-01-21 13:46:23', 40, 0),
(417, 171, 'Mon', '09:30:00', '11:00:00', 'Room 529', 57, '2026-01-21 13:46:23', 40, 0),
(418, 171, 'Fri', '09:30:00', '11:00:00', 'Room 529', 57, '2026-01-21 13:46:23', 40, 0),
(419, 172, 'Tue', '09:30:00', '11:00:00', 'Room 530', 60, '2026-01-21 13:46:23', 40, 0),
(420, 172, 'Thu', '09:30:00', '11:00:00', 'Room 530', 60, '2026-01-21 13:46:23', 40, 0),
(421, 173, 'Wed', '09:30:00', '11:00:00', 'Room 531', 50, '2026-01-21 13:46:23', 40, 0),
(422, 173, 'Tue', '14:30:00', '16:00:00', 'Room 531', 50, '2026-01-21 13:46:23', 40, 0),
(423, 174, 'Mon', '13:00:00', '14:30:00', 'Room 532', 39, '2026-01-21 13:46:23', 40, 0),
(424, 174, 'Wed', '13:00:00', '14:30:00', 'Room 532', 39, '2026-01-21 13:46:23', 40, 0),
(425, 175, 'Fri', '13:00:00', '14:30:00', 'Room 533', 53, '2026-01-21 13:46:23', 40, 0),
(426, 175, 'Tue', '13:00:00', '14:30:00', 'Room 533', 53, '2026-01-21 13:46:23', 40, 0),
(427, 176, 'Mon', '11:00:00', '12:30:00', 'Room 534', 69, '2026-01-21 13:46:23', 40, 0),
(428, 176, 'Mon', '16:00:00', '17:30:00', 'Room 534', 69, '2026-01-21 13:46:23', 40, 0),
(429, 177, 'Sat', '08:00:00', '11:00:00', 'Room 535', 57, '2026-01-21 13:46:23', 40, 1),
(430, 178, 'Tue', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 1),
(431, 178, 'Thu', '08:00:00', '17:00:00', 'Company Site', 72, '2026-01-21 13:46:23', 40, 1),
(432, 179, 'Mon', '11:00:00', '12:30:00', 'Room 536', 60, '2026-01-21 13:46:23', 40, 1),
(433, 179, 'Wed', '11:00:00', '12:30:00', 'Room 536', 60, '2026-01-21 13:46:23', 40, 1),
(434, 180, 'Wed', '09:30:00', '11:00:00', 'Room 537', 50, '2026-01-21 13:46:23', 40, 1),
(435, 180, 'Mon', '15:00:00', '16:30:00', 'Room 537', 50, '2026-01-21 13:46:23', 40, 1),
(436, 181, 'Mon', '13:00:00', '14:30:00', 'Room 538', 39, '2026-01-21 13:46:23', 40, 1),
(437, 181, 'Wed', '08:00:00', '09:30:00', 'Room 538', 39, '2026-01-21 13:46:23', 40, 1),
(438, 182, 'Mon', '08:00:00', '09:30:00', 'Room 539', 53, '2026-01-21 13:46:23', 40, 1),
(439, 182, 'Wed', '13:00:00', '14:30:00', 'Room 539', 53, '2026-01-21 13:46:23', 40, 1),
(440, 183, 'Fri', '09:30:00', '11:00:00', 'Room 540', 69, '2026-01-21 13:46:23', 40, 1),
(441, 183, 'Wed', '14:30:00', '16:00:00', 'Room 540', 69, '2026-01-21 13:46:23', 40, 1),
(442, 184, 'Fri', '13:00:00', '14:30:00', 'Room 541', 57, '2026-01-21 13:46:23', 40, 1),
(443, 184, 'Fri', '11:00:00', '12:30:00', 'Room 541', 57, '2026-01-21 13:46:23', 40, 1),
(444, 185, 'Thu', '13:00:00', '16:00:00', 'Room 535', 57, '2026-01-21 13:46:23', 40, 0),
(445, 186, 'Mon', '13:00:00', '14:30:00', 'Room 542', 60, '2026-01-21 13:46:23', 40, 0),
(446, 186, 'Wed', '13:00:00', '14:30:00', 'Room 542', 60, '2026-01-21 13:46:23', 40, 0),
(447, 187, 'Mon', '11:00:00', '12:30:00', 'Room 543', 50, '2026-01-21 13:46:23', 40, 0),
(448, 187, 'Mon', '08:00:00', '09:30:00', 'Room 543', 50, '2026-01-21 13:46:23', 40, 0),
(449, 188, 'Tue', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(450, 188, 'Thu', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(451, 189, 'Wed', '08:00:00', '09:30:00', 'Room 544', 39, '2026-01-21 13:46:23', 40, 0),
(452, 189, 'Fri', '08:00:00', '09:30:00', 'Room 544', 39, '2026-01-21 13:46:23', 40, 0),
(453, 190, 'Wed', '09:30:00', '11:00:00', 'Room 545', 53, '2026-01-21 13:46:23', 40, 0),
(454, 190, 'Fri', '09:30:00', '11:00:00', 'Room 545', 53, '2026-01-21 13:46:23', 40, 0),
(455, 191, 'Mon', '09:30:00', '11:00:00', 'Room 546', 69, '2026-01-21 13:46:23', 40, 0),
(456, 191, 'Tue', '13:00:00', '14:30:00', 'Room 546', 69, '2026-01-21 13:46:23', 40, 0),
(457, 192, 'Mon', '14:30:00', '16:00:00', 'Room 547', 57, '2026-01-21 13:46:23', 40, 0),
(458, 192, 'Tue', '15:00:00', '16:30:00', 'Room 547', 57, '2026-01-21 13:46:23', 40, 0),
(459, 257, 'Mon', '11:00:00', '12:30:00', 'Room 601', 49, '2026-01-21 13:46:23', 40, 1),
(460, 257, 'Wed', '11:00:00', '12:30:00', 'Room 601', 49, '2026-01-21 13:46:23', 40, 1),
(461, 258, 'Mon', '09:30:00', '11:00:00', 'Room 602', 62, '2026-01-21 13:46:23', 40, 1),
(462, 258, 'Thu', '09:30:00', '11:00:00', 'Room 602', 62, '2026-01-21 13:46:23', 40, 1),
(463, 259, 'Tue', '08:00:00', '09:30:00', 'Room 603', 56, '2026-01-21 13:46:23', 40, 1),
(464, 259, 'Fri', '08:00:00', '09:30:00', 'Room 603', 56, '2026-01-21 13:46:23', 40, 1),
(465, 260, 'Tue', '09:30:00', '11:00:00', 'Room 604', 64, '2026-01-21 13:46:23', 40, 1),
(466, 260, 'Mon', '14:30:00', '16:00:00', 'Room 604', 64, '2026-01-21 13:46:23', 40, 1),
(467, 261, 'Wed', '09:30:00', '11:00:00', 'Room 605', 36, '2026-01-21 13:46:23', 40, 1),
(468, 261, 'Fri', '09:30:00', '11:00:00', 'Room 605', 36, '2026-01-21 13:46:23', 40, 1),
(469, 262, 'Mon', '13:00:00', '14:30:00', 'Room 606', 30, '2026-01-21 13:46:23', 40, 1),
(470, 262, 'Wed', '13:00:00', '14:30:00', 'Room 606', 30, '2026-01-21 13:46:23', 40, 1),
(471, 263, 'Tue', '13:00:00', '14:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 1),
(472, 263, 'Thu', '13:00:00', '14:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 1),
(473, 264, 'Sat', '13:00:00', '16:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 1),
(474, 265, 'Mon', '11:00:00', '12:30:00', 'Room 607', 49, '2026-01-21 13:46:23', 40, 0),
(475, 265, 'Wed', '11:00:00', '12:30:00', 'Room 607', 49, '2026-01-21 13:46:23', 40, 0),
(476, 266, 'Tue', '08:00:00', '09:30:00', 'Room 608', 62, '2026-01-21 13:46:23', 40, 0),
(477, 266, 'Thu', '08:00:00', '09:30:00', 'Room 608', 62, '2026-01-21 13:46:23', 40, 0),
(478, 267, 'Mon', '09:30:00', '11:00:00', 'Room 609', 56, '2026-01-21 13:46:23', 40, 0),
(479, 267, 'Fri', '09:30:00', '11:00:00', 'Room 609', 56, '2026-01-21 13:46:23', 40, 0),
(480, 268, 'Tue', '09:30:00', '11:00:00', 'Lab 30', 64, '2026-01-21 13:46:23', 40, 0),
(481, 268, 'Thu', '09:30:00', '11:00:00', 'Lab 30', 64, '2026-01-21 13:46:23', 40, 0),
(482, 269, 'Wed', '09:30:00', '11:00:00', 'Room 610', 36, '2026-01-21 13:46:23', 40, 0),
(483, 269, 'Mon', '08:00:00', '09:30:00', 'Room 610', 36, '2026-01-21 13:46:23', 40, 0),
(484, 270, 'Mon', '13:00:00', '14:30:00', 'Room 611', 30, '2026-01-21 13:46:23', 40, 0),
(485, 270, 'Wed', '13:00:00', '14:30:00', 'Room 611', 30, '2026-01-21 13:46:23', 40, 0),
(486, 271, 'Tue', '13:00:00', '14:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 0),
(487, 271, 'Thu', '13:00:00', '14:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 0),
(488, 272, 'Sat', '13:00:00', '16:00:00', 'NSTP Hall', 8, '2026-01-21 13:46:23', 40, 0),
(489, 273, 'Mon', '14:30:00', '16:00:00', 'Room 612', 49, '2026-01-21 13:46:23', 40, 1),
(490, 273, 'Wed', '14:30:00', '16:00:00', 'Room 612', 49, '2026-01-21 13:46:23', 40, 1),
(491, 274, 'Mon', '08:00:00', '09:30:00', 'Room 613', 62, '2026-01-21 13:46:23', 40, 1),
(492, 274, 'Tue', '08:00:00', '09:30:00', 'Room 613', 62, '2026-01-21 13:46:23', 40, 1),
(493, 275, 'Tue', '09:30:00', '11:00:00', 'Room 614', 56, '2026-01-21 13:46:23', 40, 1),
(494, 275, 'Mon', '09:30:00', '11:00:00', 'Room 614', 56, '2026-01-21 13:46:23', 40, 1),
(495, 276, 'Tue', '16:00:00', '17:30:00', 'Room 615', 64, '2026-01-21 13:46:23', 40, 1),
(496, 276, 'Mon', '13:00:00', '14:30:00', 'Room 615', 64, '2026-01-21 13:46:23', 40, 1),
(497, 277, 'Tue', '13:00:00', '14:30:00', 'Room 616', 36, '2026-01-21 13:46:23', 40, 1),
(498, 277, 'Tue', '11:00:00', '12:30:00', 'Room 616', 36, '2026-01-21 13:46:23', 40, 1),
(499, 278, 'Mon', '11:00:00', '12:30:00', 'Room 617', 30, '2026-01-21 13:46:23', 40, 1),
(500, 278, 'Mon', '16:00:00', '17:30:00', 'Room 617', 30, '2026-01-21 13:46:23', 40, 1),
(501, 279, 'Tue', '14:30:00', '16:00:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 1),
(502, 279, 'Fri', '13:00:00', '14:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 1),
(503, 280, 'Wed', '16:00:00', '17:30:00', 'Room 618', 49, '2026-01-21 13:46:23', 40, 1),
(504, 280, 'Thu', '08:00:00', '09:30:00', 'Room 618', 49, '2026-01-21 13:46:23', 40, 1),
(505, 281, 'Mon', '14:30:00', '16:00:00', 'Lab 31', 62, '2026-01-21 13:46:23', 40, 1),
(506, 281, 'Wed', '14:30:00', '16:00:00', 'Lab 31', 62, '2026-01-21 13:46:23', 40, 1),
(507, 282, 'Tue', '08:00:00', '09:30:00', 'Room 619', 56, '2026-01-21 13:46:23', 40, 1),
(508, 282, 'Thu', '08:00:00', '09:30:00', 'Room 619', 56, '2026-01-21 13:46:23', 40, 1),
(509, 283, 'Mon', '09:30:00', '11:00:00', 'Room 620', 64, '2026-01-21 13:46:23', 40, 1),
(510, 283, 'Fri', '09:30:00', '11:00:00', 'Room 620', 64, '2026-01-21 13:46:23', 40, 1),
(511, 284, 'Tue', '09:30:00', '11:00:00', 'Room 621', 36, '2026-01-21 13:46:23', 40, 1),
(512, 284, 'Thu', '09:30:00', '11:00:00', 'Room 621', 36, '2026-01-21 13:46:23', 40, 1),
(513, 285, 'Wed', '09:30:00', '11:00:00', 'Room 622', 30, '2026-01-21 13:46:23', 40, 1),
(514, 285, 'Tue', '11:00:00', '12:30:00', 'Room 622', 30, '2026-01-21 13:46:23', 40, 1),
(515, 286, 'Mon', '13:00:00', '14:30:00', 'Room 623', 49, '2026-01-21 13:46:23', 40, 1),
(516, 286, 'Wed', '13:00:00', '14:30:00', 'Room 623', 49, '2026-01-21 13:46:23', 40, 1),
(517, 287, 'Mon', '08:00:00', '09:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 1),
(518, 287, 'Mon', '11:00:00', '12:30:00', 'Gym', 41, '2026-01-21 13:46:23', 40, 1),
(519, 288, 'Tue', '13:00:00', '14:30:00', 'Room 624', 62, '2026-01-21 13:46:23', 40, 1),
(520, 288, 'Mon', '16:00:00', '17:30:00', 'Room 624', 62, '2026-01-21 13:46:23', 40, 1),
(521, 289, 'Mon', '13:00:00', '14:30:00', 'Room 625', 56, '2026-01-21 13:46:23', 40, 2),
(522, 289, 'Wed', '13:00:00', '14:30:00', 'Room 625', 56, '2026-01-21 13:46:23', 40, 2),
(523, 290, 'Mon', '09:30:00', '11:00:00', 'Room 626', 64, '2026-01-21 13:46:23', 40, 2),
(524, 290, 'Mon', '11:00:00', '12:30:00', 'Room 626', 64, '2026-01-21 13:46:23', 40, 2),
(525, 291, 'Tue', '08:00:00', '09:30:00', 'Room 627', 36, '2026-01-21 13:46:23', 40, 2),
(526, 291, 'Fri', '08:00:00', '09:30:00', 'Room 627', 36, '2026-01-21 13:46:23', 40, 2),
(527, 292, 'Tue', '09:30:00', '11:00:00', 'Room 628', 30, '2026-01-21 13:46:23', 40, 2),
(528, 292, 'Thu', '09:30:00', '11:00:00', 'Room 628', 30, '2026-01-21 13:46:23', 40, 2),
(529, 293, 'Wed', '09:30:00', '11:00:00', 'Room 629', 49, '2026-01-21 13:46:23', 40, 2),
(530, 293, 'Fri', '09:30:00', '11:00:00', 'Room 629', 49, '2026-01-21 13:46:23', 40, 2),
(531, 294, 'Tue', '11:00:00', '12:30:00', 'Room 630', 62, '2026-01-21 13:46:23', 40, 2),
(532, 294, 'Tue', '13:00:00', '14:30:00', 'Room 630', 62, '2026-01-21 13:46:23', 40, 2),
(533, 295, 'Fri', '13:00:00', '14:30:00', 'Room 631', 56, '2026-01-21 13:46:23', 40, 2),
(534, 295, 'Mon', '14:30:00', '16:00:00', 'Room 631', 56, '2026-01-21 13:46:23', 40, 2),
(535, 296, 'Mon', '16:00:00', '17:30:00', 'Room 632', 64, '2026-01-21 13:46:23', 40, 2),
(536, 296, 'Fri', '15:00:00', '16:30:00', 'Room 632', 64, '2026-01-21 13:46:23', 40, 2),
(537, 297, 'Mon', '08:00:00', '11:00:00', 'Demo School', 71, '2026-01-21 13:46:23', 40, 1),
(538, 297, 'Wed', '08:00:00', '11:00:00', 'Demo School', 71, '2026-01-21 13:46:23', 40, 1),
(539, 298, 'Tue', '08:00:00', '09:30:00', 'Room 633', 36, '2026-01-21 13:46:23', 40, 1),
(540, 298, 'Thu', '08:00:00', '09:30:00', 'Room 633', 36, '2026-01-21 13:46:23', 40, 1),
(541, 299, 'Mon', '11:00:00', '12:30:00', 'Room 634', 30, '2026-01-21 13:46:23', 40, 1),
(542, 299, 'Fri', '13:00:00', '14:30:00', 'Room 634', 30, '2026-01-21 13:46:23', 40, 1),
(543, 300, 'Tue', '09:30:00', '11:00:00', 'Room 635', 49, '2026-01-21 13:46:23', 40, 1),
(544, 300, 'Thu', '09:30:00', '11:00:00', 'Room 635', 49, '2026-01-21 13:46:23', 40, 1),
(545, 301, 'Wed', '13:00:00', '14:30:00', 'Room 636', 62, '2026-01-21 13:46:23', 40, 1),
(546, 301, 'Wed', '11:00:00', '12:30:00', 'Room 636', 62, '2026-01-21 13:46:23', 40, 1),
(547, 302, 'Fri', '08:00:00', '09:30:00', 'Room 637', 56, '2026-01-21 13:46:23', 40, 1),
(548, 302, 'Mon', '14:30:00', '16:00:00', 'Room 637', 56, '2026-01-21 13:46:23', 40, 1),
(549, 303, 'Tue', '13:00:00', '14:30:00', 'Room 638', 64, '2026-01-21 13:46:23', 40, 1),
(550, 303, 'Thu', '15:00:00', '16:30:00', 'Room 638', 64, '2026-01-21 13:46:23', 40, 1),
(551, 304, 'Thu', '13:00:00', '14:30:00', 'Room 639', 36, '2026-01-21 13:46:23', 40, 1),
(552, 304, 'Tue', '15:00:00', '16:30:00', 'Room 639', 36, '2026-01-21 13:46:23', 40, 1),
(553, 305, 'Mon', '08:00:00', '11:00:00', 'Room 640', 30, '2026-01-21 13:46:23', 40, 1),
(554, 306, 'Tue', '08:00:00', '17:00:00', 'Partner School', 71, '2026-01-21 13:46:23', 40, 1),
(555, 306, 'Thu', '08:00:00', '17:00:00', 'Partner School', 71, '2026-01-21 13:46:23', 40, 1),
(556, 307, 'Wed', '08:00:00', '09:30:00', 'Room 641', 49, '2026-01-21 13:46:23', 40, 1),
(557, 307, 'Wed', '13:00:00', '14:30:00', 'Room 641', 49, '2026-01-21 13:46:23', 40, 1),
(558, 308, 'Wed', '09:30:00', '11:00:00', 'Room 642', 62, '2026-01-21 13:46:23', 40, 1),
(559, 308, 'Mon', '15:00:00', '16:30:00', 'Room 642', 62, '2026-01-21 13:46:23', 40, 1),
(560, 309, 'Mon', '11:00:00', '12:30:00', 'Room 643', 56, '2026-01-21 13:46:23', 40, 1),
(561, 309, 'Wed', '11:00:00', '12:30:00', 'Room 643', 56, '2026-01-21 13:46:23', 40, 1),
(562, 310, 'Fri', '08:00:00', '09:30:00', 'Room 644', 64, '2026-01-21 13:46:23', 40, 1),
(563, 310, 'Wed', '14:30:00', '16:00:00', 'Room 644', 64, '2026-01-21 13:46:23', 40, 1),
(564, 311, 'Mon', '13:00:00', '14:30:00', 'Room 645', 36, '2026-01-21 13:46:23', 40, 1),
(565, 311, 'Wed', '16:00:00', '17:30:00', 'Room 645', 36, '2026-01-21 13:46:23', 40, 1),
(566, 312, 'Fri', '13:00:00', '14:30:00', 'Room 646', 30, '2026-01-21 13:46:23', 40, 1),
(567, 312, 'Fri', '09:30:00', '11:00:00', 'Room 646', 30, '2026-01-21 13:46:23', 40, 1),
(568, 313, 'Mon', '08:00:00', '11:00:00', 'Room 640', 30, '2026-01-21 13:46:23', 40, 0),
(569, 314, 'Mon', '14:30:00', '16:00:00', 'Room 647', 49, '2026-01-21 13:46:23', 40, 0),
(570, 314, 'Mon', '16:00:00', '17:30:00', 'Room 647', 49, '2026-01-21 13:46:23', 40, 0),
(571, 315, 'Mon', '11:00:00', '12:30:00', 'Room 648', 62, '2026-01-21 13:46:23', 40, 0),
(572, 315, 'Mon', '13:00:00', '14:30:00', 'Room 648', 62, '2026-01-21 13:46:23', 40, 0),
(573, 316, 'Tue', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(574, 316, 'Thu', '09:30:00', '11:00:00', 'Auditorium', 73, '2026-01-21 13:46:23', 40, 0),
(575, 317, 'Tue', '11:00:00', '12:30:00', 'Room 649', 56, '2026-01-21 13:46:23', 40, 0),
(576, 317, 'Wed', '11:00:00', '12:30:00', 'Room 649', 56, '2026-01-21 13:46:23', 40, 0),
(577, 318, 'Wed', '09:30:00', '11:00:00', 'Room 650', 64, '2026-01-21 13:46:23', 40, 0),
(578, 318, 'Wed', '08:00:00', '09:30:00', 'Room 650', 64, '2026-01-21 13:46:23', 40, 0),
(579, 319, 'Tue', '13:00:00', '14:30:00', 'Room 651', 36, '2026-01-21 13:46:23', 40, 0),
(580, 320, 'Tue', '08:00:00', '09:30:00', 'Room 652', 30, '2026-01-21 13:46:23', 40, 0),
(581, 320, 'Tue', '15:00:00', '16:30:00', 'Room 652', 30, '2026-01-21 13:46:23', 40, 0);

-- --------------------------------------------------------

--
-- Table structure for table `scholarships`
--

CREATE TABLE `scholarships` (
  `scholarship_id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `discount_type` enum('percentage','fixed') NOT NULL DEFAULT 'percentage',
  `discount_value` decimal(10,2) NOT NULL DEFAULT 0.00,
  `applies_to` enum('tuition','misc','all') DEFAULT 'tuition',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `scholarships`
--

INSERT INTO `scholarships` (`scholarship_id`, `code`, `name`, `description`, `discount_type`, `discount_value`, `applies_to`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'ACAD_FULL', 'Full Academic Scholarship', 'Full tuition waiver for academic excellence', 'percentage', 100.00, 'tuition', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(2, 'ACAD_HALF', 'Half Academic Scholarship', '50% tuition discount for academic excellence', 'percentage', 50.00, 'tuition', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(3, 'ACAD_25', 'Partial Academic Scholarship', '25% tuition discount', 'percentage', 25.00, 'tuition', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(4, 'SIBLING', 'Sibling Discount', '10% discount for siblings enrolled', 'percentage', 10.00, 'tuition', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(5, 'ALUMNI', 'Alumni Dependent Discount', '15% discount for children of alumni', 'percentage', 15.00, 'tuition', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(6, 'ATHLETE', 'Athletic Scholarship', 'Full scholarship for varsity athletes', 'percentage', 100.00, 'all', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(7, 'FINANCIAL_AID', 'Financial Assistance', 'Need-based financial aid', 'percentage', 50.00, 'all', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11'),
(8, 'EMPLOYEE', 'Employee Dependent', 'Free tuition for employee dependents', 'percentage', 100.00, 'tuition', 1, '2026-01-30 14:34:11', '2026-01-30 14:34:11');

-- --------------------------------------------------------

--
-- Table structure for table `semester_status`
--

CREATE TABLE `semester_status` (
  `status_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `year_level` int(11) NOT NULL,
  `semester` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `status` enum('In Progress','Completed','Incomplete') DEFAULT 'In Progress',
  `gpa` decimal(3,2) DEFAULT NULL,
  `total_units` int(11) DEFAULT 0,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `semester_status`
--

INSERT INTO `semester_status` (`status_id`, `student_id`, `year_level`, `semester`, `academic_year`, `status`, `gpa`, `total_units`, `completed_at`, `created_at`, `updated_at`) VALUES
(1, 5, 1, 2, '2025-2026', 'Completed', NULL, 0, NULL, '2026-01-25 07:35:40', '2026-01-25 07:36:03'),
(2, 5, 2, 1, '2026-2027', 'In Progress', NULL, 0, NULL, '2026-01-25 07:36:32', '2026-01-25 07:36:32'),
(3, 9, 4, 2, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 07:41:47', '2026-01-25 07:41:47'),
(4, 8, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 07:41:50', '2026-01-25 07:41:50'),
(5, 7, 4, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 07:41:54', '2026-01-25 07:41:54'),
(7, 12, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 07:45:49', '2026-01-25 07:45:49'),
(8, 10, 3, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 07:46:01', '2026-01-25 07:46:01'),
(9, 11, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 07:46:06', '2026-01-25 07:46:06'),
(10, 23, 2, 1, '2025-2026', 'Completed', NULL, 0, NULL, '2026-01-25 08:00:36', '2026-01-25 08:18:11'),
(11, 16, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 08:00:41', '2026-01-25 08:00:41'),
(12, 19, 1, 2, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 08:00:46', '2026-01-25 08:00:46'),
(13, 24, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 08:00:49', '2026-01-25 08:00:49'),
(14, 14, 2, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 08:01:03', '2026-01-25 08:01:03'),
(15, 21, 3, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-25 08:01:05', '2026-01-25 08:01:05'),
(16, 23, 2, 2, '2025-2026', 'Completed', NULL, 0, NULL, '2026-01-25 08:18:19', '2026-01-25 08:18:43'),
(17, 23, 3, 1, '2026-2027', 'Completed', NULL, 0, NULL, '2026-01-25 08:18:50', '2026-01-30 16:36:00'),
(18, 23, 3, 2, '2026-2027', 'In Progress', NULL, 0, NULL, '2026-01-30 16:36:21', '2026-01-30 16:36:21'),
(19, 25, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:39:22', '2026-01-30 16:39:22'),
(20, 22, 4, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:40:21', '2026-01-30 16:40:21'),
(21, 13, 4, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:40:28', '2026-01-30 16:40:28'),
(22, 15, 2, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:40:37', '2026-01-30 16:40:37'),
(23, 17, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:41:12', '2026-01-30 16:41:12'),
(24, 20, 2, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:41:25', '2026-01-30 16:41:25'),
(25, 18, 4, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-01-30 16:41:39', '2026-01-30 16:41:39'),
(27, 26, 1, 1, '2025-2026', 'In Progress', NULL, 0, NULL, '2026-02-02 14:31:46', '2026-02-02 14:31:46');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `student_number` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  `year_level` int(11) DEFAULT 1,
  `current_semester` int(11) DEFAULT 1,
  `cumulative_gpa` decimal(3,2) DEFAULT NULL,
  `academic_standing` varchar(50) DEFAULT 'Good Standing',
  `status` enum('Active','Inactive','Graduated') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `student_number`, `first_name`, `middle_name`, `last_name`, `email`, `phone`, `address`, `date_of_birth`, `gender`, `program_id`, `year_level`, `current_semester`, `cumulative_gpa`, `academic_standing`, `status`, `created_at`, `updated_at`) VALUES
(5, '2026-00002', 'Aliya Neiah', 'Ohdo', 'Rufila21', 'aliyaneiah@gmail.com', '09246823951', 'Brgy. San Roque, Macrohon Southern Leyte', '2005-07-08', 'Female', 2, 2, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:15:42', '2026-01-25 07:36:03'),
(7, '2026-00004', 'Juan', 'Perez', 'Santos21', 'juan.santos21@gmail.com', '09171234567', '123 Rizal St, Brgy. 64, Tondo, Manila', '2003-09-19', 'Male', 2, 4, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:39:06', '2026-01-25 07:39:06'),
(8, '2026-00005', 'Maria Clara', 'Dizon', 'Dela Cruz21', 'mariaclara.delacruz21@gmail.com', '09182345678', '45 Magsaysay Ave, Brgy. Guadalupe, Cebu City', '2004-12-26', 'Female', 2, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:40:12', '2026-01-25 07:40:12'),
(9, '2026-00006', 'Jose', 'Mari', 'Chan21', 'jose.chan21@gmail.com', '09203456789', '88 Moonleaf St, Brgy. Buhangin, Davao City', '2002-12-25', 'Male', 1, 4, 2, NULL, 'Good Standing', 'Active', '2026-01-25 07:41:30', '2026-01-25 07:41:30'),
(10, '2026-00007', 'Angel Locsin', 'Mercado', 'Colmenares21', 'angel.colmenares21@gmail.com', '09154567890', 'Unit 402, Sunshine Condo, Ortigas Center, Pasig', '2003-07-30', 'Male', 1, 3, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:42:38', '2026-01-25 07:42:38'),
(11, '2026-00008', 'Paolo', 'Ballesteros', 'Garcia21', 'paolo.garcia21@gmail.com', '09275678901', '12 Narra Lane, Brgy. San Jose, Quezon City', '2005-01-01', 'Male', 1, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:43:29', '2026-01-25 07:43:29'),
(12, '2026-00009', 'Catriona', 'Magnayon', 'Gray21', 'catriona.gray21@gmail.com', '09086789012', 'Block 5 Lot 12, Avida Village, Biñan, Laguna', '2005-10-30', 'Female', 1, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:45:40', '2026-01-25 07:45:40'),
(13, '2026-00010', 'Manny', 'Dapidran', 'Pacquiao21', 'manny.pacquiao21@gmail.com', '09197890123', 'Poblacion Road, General Santos City', '2002-09-21', 'Male', 3, 4, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:47:35', '2026-01-25 07:47:35'),
(14, '2026-00011', 'Liza', 'Soberano', 'Esperanza21', 'liza.esperanza21@gmail.com', '09168901234', '77 Diamond St, Brgy. Kapitolyo, Pasig', '2002-03-11', 'Female', 3, 2, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:48:56', '2026-01-25 07:48:56'),
(15, '2026-00012', 'Daniel', 'Ford', 'Padilla21', 'daniel.padilla21@gmail.com', '09219012345', '901 Aurora Blvd, Cubao, Quezon City', '2002-07-21', 'Male', 3, 2, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:50:10', '2026-01-25 07:50:10'),
(16, '2026-00013', 'Kathryn', 'Chandria', 'Bernardo21', 'kathryn.bernardo21@gmail.com', '09170123456', 'Phase 3, Greenview Subd, Antipolo, Rizal', '2005-09-05', 'Female', 3, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:51:10', '2026-01-25 07:51:10'),
(17, '2026-00014', 'Jericho', 'Vibar', 'Rosales21', 'jericho.rosales21@gmail.com', '09181234567', '15 Orchid St, Brgy. Lahug, Cebu City', '2004-08-25', 'Male', 4, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:53:58', '2026-01-25 07:53:58'),
(18, '2026-00015', 'Pia', 'Alonzo', 'Wurtzbach21', 'pia.wurtzbach21@gmail.com', '09222345678', '22 BGC High Street, Taguig City', '2002-04-26', 'Female', 4, 4, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:54:50', '2026-01-25 07:54:50'),
(19, '2026-00016', 'Vic', 'Sotto', 'Castelo21', 'vic.castelo21@gmail.com', '09203456789', '101 Acacia Ave, Ayala Alabang, Muntinlupa', '2004-01-10', 'Male', 4, 1, 2, NULL, 'Good Standing', 'Active', '2026-01-25 07:55:41', '2026-01-25 07:55:41'),
(20, '2026-00017', 'Lea', 'Carmen', 'Salonga21', 'lea.salonga21@gmail.com', '09154567890', '56 Jasmine St, Forbes Park, Makati', '2003-02-14', 'Female', 4, 2, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:56:27', '2026-01-25 07:56:27'),
(21, '2026-00018', 'Alden', 'Richard', 'Faulkerson21', 'alden.faulkerson21@gmail.com', '09275678901', 'Brgy. Concepcion, Marikina City', '2004-03-20', 'Male', 5, 3, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:57:18', '2026-01-25 07:57:18'),
(22, '2026-00019', 'Maine', 'Capili', 'Mendoza21', 'maine.mendoza21@gmail.com', '09086789012', 'Sta. Maria, Bulacan, Philippines', '2002-04-05', 'Female', 5, 4, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:58:01', '2026-01-25 07:58:01'),
(23, '2026-00020', 'Isabel', 'Preysler', 'Arrastia21', 'isabel.arrastia21@gmail.com', '09168901234', '14 Jupiter St, Bel-Air Village, Makati', '2002-05-20', 'Female', 5, 3, 2, NULL, 'Good Standing', 'Active', '2026-01-25 07:58:45', '2026-01-30 16:36:00'),
(24, '2026-00021', 'Rico', 'Yan', 'Castro21', 'rico.castro21@gmail.com', '09219012345', '33 Bluebird St, Brgy. Ugong, Valenzuela', '2005-06-11', 'Male', 5, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-25 07:59:24', '2026-01-25 07:59:24'),
(25, '2026-00022', 'Francisco', 'Amolo', 'Cano21', 'francisco@gmail.com', '09458649283', 'Brgy. Combado, Maasin City, Southern Leyte', '2004-03-01', 'Male', 2, 1, 1, NULL, 'Good Standing', 'Active', '2026-01-30 15:38:53', '2026-01-30 15:38:53'),
(26, '2026-00023', 'Reginald', 'Amolo', 'Cano', 'reginaldcano@gmail.com', '09677701376', 'Brgy. Combado, Maasin City, Southern Leyte', '2004-05-11', 'Male', 2, 1, 1, NULL, 'Good Standing', 'Active', '2026-02-02 14:31:36', '2026-02-02 14:31:36');

-- --------------------------------------------------------

--
-- Table structure for table `student_late_fees`
--

CREATE TABLE `student_late_fees` (
  `late_fee_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `applied_date` date NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `is_waived` tinyint(1) DEFAULT 0,
  `waived_by` varchar(100) DEFAULT NULL,
  `waived_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_scholarships`
--

CREATE TABLE `student_scholarships` (
  `student_scholarship_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `scholarship_id` int(11) NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `semester` int(11) NOT NULL,
  `status` enum('Active','Revoked','Expired') DEFAULT 'Active',
  `awarded_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `setting_id` int(11) NOT NULL,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`setting_id`, `setting_key`, `setting_value`, `description`, `updated_at`) VALUES
(1, 'current_academic_year', '2025-2026', 'The currently active academic year for enrollment', '2026-01-22 12:30:35'),
(2, 'current_semester', '1', 'The currently active semester (1 or 2)', '2026-01-22 12:30:35');

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `status` enum('Active','Inactive','On Leave') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`teacher_id`, `first_name`, `last_name`, `title`, `email`, `phone`, `department`, `status`, `created_at`) VALUES
(1, 'Juan', 'Garcia', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(2, 'Maria', 'Santos', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(3, 'Jose', 'Reyes', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(4, 'Ana', 'Cruz', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(5, 'Pedro', 'Mendoza', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(6, 'Rosa', 'Flores', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(7, 'Miguel', 'Tan', 'Coach', NULL, NULL, 'Physical Education', 'Active', '2026-01-21 13:46:23'),
(8, 'Luis', 'Ramos', 'Sir', NULL, NULL, 'NSTP', 'Active', '2026-01-21 13:46:23'),
(9, 'Carlos', 'Villanueva', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(10, 'Elena', 'Bautista', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(11, 'Roberto', 'Aquino', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(12, 'Carmen', 'Dela Cruz', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(13, 'Antonio', 'Navarro', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(14, 'Sofia', 'Robles', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(15, 'Manuel', 'Fernandez', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(16, 'Patricia', 'Morales', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(17, 'Ricardo', 'Castro', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(18, 'Teresa', 'Rivera', 'Prof.', NULL, NULL, 'Information Systems', 'Active', '2026-01-21 13:46:23'),
(19, 'Francisco', 'Torres', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(20, 'Gloria', 'Gonzales', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(21, 'David', 'Lim', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(22, 'Grace', 'Ong', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(23, 'Henry', 'Sy', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(24, 'Isabel', 'Go', 'Prof.', NULL, NULL, 'Information Systems', 'Active', '2026-01-21 13:46:23'),
(25, 'James', 'Co', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(26, 'Karen', 'Ang', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(27, 'Leo', 'Yap', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(28, 'Megan', 'Chua', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(29, 'Nathan', 'Diaz', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(30, 'Olivia', 'Padilla', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(31, 'Pablo', 'Ocampo', 'Prof.', NULL, NULL, 'Information Systems', 'Active', '2026-01-21 13:46:23'),
(32, 'Queen', 'Medina', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(33, 'Raymond', 'Martinez', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(34, 'Sarah', 'Hernandez', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(35, 'Thomas', 'Jimenez', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(36, 'Uma', 'Lacson', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(37, 'Victor', 'Salazar', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(38, 'Wendy', 'Pascual', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(39, 'Xavier', 'Ignacio', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(40, 'Yolanda', 'Ruiz', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(41, 'Mario', 'Gomez', 'Coach', NULL, NULL, 'Physical Education', 'Active', '2026-01-21 13:46:23'),
(42, 'Carlos', 'Lopez', 'Coach', NULL, NULL, 'Physical Education', 'Active', '2026-01-21 13:46:23'),
(43, 'Roberto', 'Reyes', 'Coach', NULL, NULL, 'Physical Education', 'Active', '2026-01-21 13:46:23'),
(44, 'Jose', 'Santos', 'Coach', NULL, NULL, 'Physical Education', 'Active', '2026-01-21 13:46:23'),
(45, 'Anna', 'Aguilar', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(46, 'Diana', 'Alvarado', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(47, 'Eduardo', 'Bernardo', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(48, 'Franco', 'Castillo', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(49, 'Gina', 'Dela Rosa', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(50, 'Hugo', 'Dizon', 'Prof.', NULL, NULL, 'Information Systems', 'Active', '2026-01-21 13:46:23'),
(51, 'Irene', 'Domingo', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(52, 'Julia', 'Espinosa', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(53, 'Kevin', 'Francisco', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(54, 'Linda', 'Lopez', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(55, 'Marco', 'Luna', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(56, 'Nancy', 'Magbanua', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(57, 'Oscar', 'Manalo', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(58, 'Paula', 'Mendez', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(59, 'Rey', 'Mercado', 'Prof.', NULL, NULL, 'Information Systems', 'Active', '2026-01-21 13:46:23'),
(60, 'Samuel', 'Ramos', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(61, 'Tina', 'Romero', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(62, 'Ulysses', 'Salonga', 'Prof.', NULL, NULL, 'Information Technology', 'Active', '2026-01-21 13:46:23'),
(63, 'Vera', 'Soriano', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(64, 'Walter', 'Sotto', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(65, 'Angelo', 'Tan', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(66, 'Beatriz', 'Tolentino', 'Prof.', NULL, NULL, 'Business Administration', 'Active', '2026-01-21 13:46:23'),
(67, 'Cesar', 'Valdez', 'Prof.', NULL, NULL, 'Information Systems', 'Active', '2026-01-21 13:46:23'),
(68, 'Delia', 'Vargas', 'Prof.', NULL, NULL, 'General Education', 'Active', '2026-01-21 13:46:23'),
(69, 'Ernesto', 'Velasco', 'Prof.', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(70, 'Fiona', 'Zamora', 'Prof.', NULL, NULL, 'Computer Science', 'Active', '2026-01-21 13:46:23'),
(71, 'N/A', 'Cooperating Teacher', '', NULL, NULL, 'Education', 'Active', '2026-01-21 13:46:23'),
(72, 'N/A', 'Industry Supervisor', '', NULL, NULL, 'Industry', 'Active', '2026-01-21 13:46:23'),
(73, 'N/A', 'Various Speakers', '', NULL, NULL, 'General', 'Active', '2026-01-21 13:46:23');

-- --------------------------------------------------------

--
-- Table structure for table `term_overpayments`
--

CREATE TABLE `term_overpayments` (
  `overpayment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `source_academic_year` varchar(20) NOT NULL,
  `source_semester` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `applied_academic_year` varchar(20) DEFAULT NULL,
  `applied_semester` int(11) DEFAULT NULL,
  `is_applied` tinyint(1) DEFAULT 0,
  `applied_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_standings`
--
ALTER TABLE `academic_standings`
  ADD PRIMARY KEY (`standing_id`),
  ADD UNIQUE KEY `unique_standing` (`student_id`,`academic_year`,`semester`),
  ADD KEY `idx_standing` (`standing`),
  ADD KEY `idx_student_standing` (`student_id`,`academic_year`);

--
-- Indexes for table `academic_standing_config`
--
ALTER TABLE `academic_standing_config`
  ADD PRIMARY KEY (`config_id`),
  ADD UNIQUE KEY `unique_standing_config` (`standing`);

--
-- Indexes for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD PRIMARY KEY (`prereq_id`),
  ADD UNIQUE KEY `unique_prereq` (`curriculum_id`,`required_curriculum_id`),
  ADD KEY `required_curriculum_id` (`required_curriculum_id`),
  ADD KEY `idx_prereq_course` (`curriculum_id`);

--
-- Indexes for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD PRIMARY KEY (`curriculum_id`),
  ADD KEY `idx_program_year_sem` (`program_id`,`year_level`,`semester`),
  ADD KEY `fk_prerequisite` (`prerequisite_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD UNIQUE KEY `unique_enrollment` (`student_id`,`curriculum_id`,`academic_year`),
  ADD KEY `curriculum_id` (`curriculum_id`),
  ADD KEY `idx_student_year` (`student_id`,`academic_year`),
  ADD KEY `idx_enrollment_status` (`status`);

--
-- Indexes for table `fees`
--
ALTER TABLE `fees`
  ADD PRIMARY KEY (`fee_id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `late_fee_config`
--
ALTER TABLE `late_fee_config`
  ADD PRIMARY KEY (`config_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`program_id`),
  ADD UNIQUE KEY `program_code` (`program_code`);

--
-- Indexes for table `program_tuition_rates`
--
ALTER TABLE `program_tuition_rates`
  ADD PRIMARY KEY (`rate_id`),
  ADD UNIQUE KEY `unique_program_rate` (`program_id`,`effective_date`),
  ADD KEY `idx_program_active` (`program_id`,`is_active`);

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `idx_curriculum` (`curriculum_id`),
  ADD KEY `idx_schedule_day` (`curriculum_id`,`day_of_week`),
  ADD KEY `idx_teacher` (`teacher_id`);

--
-- Indexes for table `scholarships`
--
ALTER TABLE `scholarships`
  ADD PRIMARY KEY (`scholarship_id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `semester_status`
--
ALTER TABLE `semester_status`
  ADD PRIMARY KEY (`status_id`),
  ADD UNIQUE KEY `unique_semester` (`student_id`,`year_level`,`semester`,`academic_year`),
  ADD KEY `idx_student_status` (`student_id`,`status`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `student_number` (`student_number`),
  ADD KEY `idx_program` (`program_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_name_search` (`last_name`,`first_name`);

--
-- Indexes for table `student_late_fees`
--
ALTER TABLE `student_late_fees`
  ADD PRIMARY KEY (`late_fee_id`),
  ADD KEY `idx_student_term_late` (`student_id`,`academic_year`,`semester`);

--
-- Indexes for table `student_scholarships`
--
ALTER TABLE `student_scholarships`
  ADD PRIMARY KEY (`student_scholarship_id`),
  ADD UNIQUE KEY `unique_student_scholarship_term` (`student_id`,`scholarship_id`,`academic_year`,`semester`),
  ADD KEY `scholarship_id` (`scholarship_id`),
  ADD KEY `idx_student_term` (`student_id`,`academic_year`,`semester`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`setting_id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`),
  ADD KEY `idx_department` (`department`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `term_overpayments`
--
ALTER TABLE `term_overpayments`
  ADD PRIMARY KEY (`overpayment_id`),
  ADD KEY `idx_student_overpayment` (`student_id`,`is_applied`),
  ADD KEY `idx_source_term` (`student_id`,`source_academic_year`,`source_semester`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_standings`
--
ALTER TABLE `academic_standings`
  MODIFY `standing_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `academic_standing_config`
--
ALTER TABLE `academic_standing_config`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  MODIFY `prereq_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `curriculum`
--
ALTER TABLE `curriculum`
  MODIFY `curriculum_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=324;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=291;

--
-- AUTO_INCREMENT for table `fees`
--
ALTER TABLE `fees`
  MODIFY `fee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `late_fee_config`
--
ALTER TABLE `late_fee_config`
  MODIFY `config_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `program_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `program_tuition_rates`
--
ALTER TABLE `program_tuition_rates`
  MODIFY `rate_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=585;

--
-- AUTO_INCREMENT for table `scholarships`
--
ALTER TABLE `scholarships`
  MODIFY `scholarship_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `semester_status`
--
ALTER TABLE `semester_status`
  MODIFY `status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `student_late_fees`
--
ALTER TABLE `student_late_fees`
  MODIFY `late_fee_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_scholarships`
--
ALTER TABLE `student_scholarships`
  MODIFY `student_scholarship_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `setting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `term_overpayments`
--
ALTER TABLE `term_overpayments`
  MODIFY `overpayment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academic_standings`
--
ALTER TABLE `academic_standings`
  ADD CONSTRAINT `academic_standings_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD CONSTRAINT `course_prerequisites_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`curriculum_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_prerequisites_ibfk_2` FOREIGN KEY (`required_curriculum_id`) REFERENCES `curriculum` (`curriculum_id`) ON DELETE CASCADE;

--
-- Constraints for table `curriculum`
--
ALTER TABLE `curriculum`
  ADD CONSTRAINT `curriculum_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_prerequisite` FOREIGN KEY (`prerequisite_id`) REFERENCES `curriculum` (`curriculum_id`) ON DELETE SET NULL;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`curriculum_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`);

--
-- Constraints for table `program_tuition_rates`
--
ALTER TABLE `program_tuition_rates`
  ADD CONSTRAINT `program_tuition_rates_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`) ON DELETE CASCADE;

--
-- Constraints for table `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculum` (`curriculum_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE SET NULL;

--
-- Constraints for table `semester_status`
--
ALTER TABLE `semester_status`
  ADD CONSTRAINT `semester_status_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`) ON DELETE SET NULL;

--
-- Constraints for table `student_late_fees`
--
ALTER TABLE `student_late_fees`
  ADD CONSTRAINT `student_late_fees_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_scholarships`
--
ALTER TABLE `student_scholarships`
  ADD CONSTRAINT `student_scholarships_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_scholarships_ibfk_2` FOREIGN KEY (`scholarship_id`) REFERENCES `scholarships` (`scholarship_id`) ON DELETE CASCADE;

--
-- Constraints for table `term_overpayments`
--
ALTER TABLE `term_overpayments`
  ADD CONSTRAINT `term_overpayments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
