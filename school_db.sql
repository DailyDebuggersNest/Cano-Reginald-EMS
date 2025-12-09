-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2025 at 06:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `school_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `class_schedules`
--

CREATE TABLE `class_schedules` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `room` varchar(100) DEFAULT NULL,
  `schedule_day` varchar(50) DEFAULT NULL,
  `schedule_time` varchar(50) DEFAULT NULL,
  `school_year` varchar(20) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `class_schedules`
--

INSERT INTO `class_schedules` (`id`, `subject_id`, `room`, `schedule_day`, `schedule_time`, `school_year`, `semester`, `teacher_id`) VALUES
(1, 1, 'Room 101', 'Mon-Wed', '7:30 AM - 9:00 AM', '2024-2025', '1st Semester', 1),
(2, 2, 'Room 102', 'Tue-Thu', '9:00 AM - 10:30 AM', '2024-2025', '1st Semester', 2),
(3, 3, 'Room 203', 'Mon', '1:00 PM - 3:00 PM', '2024-2025', '1st Semester', 3),
(4, 4, 'Room 204', 'Wed', '10:30 AM - 12:00 PM', '2024-2025', '1st Semester', 1),
(5, 5, 'Gym', 'Fri', '8:00 AM - 10:00 AM', '2024-2025', '1st Semester', 2),
(6, 6, 'Lab 201', 'Mon-Wed', '7:30 AM - 9:00 AM', '2024-2025', '1st Semester', 2),
(7, 7, 'Room 104', 'Tue-Thu', '9:00 AM - 10:30 AM', '2024-2025', '1st Semester', 1),
(8, 8, 'Room 205', 'Mon', '1:00 PM - 3:00 PM', '2024-2025', '1st - Semester', 3),
(9, 9, 'Room 206', 'Wed', '10:30 AM - 12:00 PM', '2024-2025', '2nd Semester', 1),
(10, 10, 'Gym', 'Fri', '8:00 AM - 10:00 AM', '2024-2025', '2nd Semester', 2),
(11, 11, 'Room 303', 'Mon-Wed', '1:30 PM - 3:00 PM', '2024-2025', '2nd Semester', 2),
(12, 12, 'Auditorium', 'Tue-Thu', '3:00 PM - 4:30 PM', '2024-2025', '2nd Semester', 3),
(13, 13, 'Room 405', 'Fri', '8:30 AM - 9:30 AM', '2024-2025', '2nd Semester', 1),
(14, 14, 'Room 103', 'Tue', '1:30 PM - 3:30 PM', '2024-2025', '2nd Semester', 3),
(15, 15, 'Lab 107', 'Thu', '10:30 AM - 12:00 PM', '2024-2025', '2nd Semester', 3),
(16, 16, 'Room 402', 'Fri', '1:00 PM - 2:30 PM', '2024-2025', '2nd semester', 2);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `course_code` varchar(50) DEFAULT NULL,
  `course_name` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `course_code`, `course_name`) VALUES
(1, 'BSCS', 'Bachelor of Science in Computer Science'),
(2, 'BSIT', 'Bachelor of Science in Information Technology'),
(3, 'BSN', 'Bachelor of Science in Nursing '),
(4, 'BSA', 'Bachelor of Science in Accountancy ');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `school_year` varchar(20) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL,
  `date_enrolled` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `student_id`, `course_id`, `school_year`, `semester`, `date_enrolled`) VALUES
(1, 1, 1, '2024-2025', '1st ', '2025-12-07 08:38:23'),
(2, 1, 1, '2024-2025', '2nd ', '2025-12-07 08:46:21'),
(3, 2, 1, '2024-2025', '1st', '2025-12-08 08:39:31'),
(4, 2, 1, '2024-2025', '2nd', '2025-12-08 08:39:31'),
(5, 3, 2, '2024-2025', '1st', '2025-12-08 08:40:40'),
(6, 3, 2, '2024-2025', '2nd', '2025-12-08 08:40:40'),
(7, 4, 2, '2024-2025', '1st ', '2025-12-08 11:20:04'),
(8, 4, 2, '2024-2025', '2nd ', '2025-12-08 11:20:04');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_subjects`
--

CREATE TABLE `enrollment_subjects` (
  `id` int(11) NOT NULL,
  `enrollment_id` int(11) NOT NULL,
  `class_schedule_id` int(11) NOT NULL,
  `final_grade` decimal(5,2) DEFAULT NULL,
  `remarks` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment_subjects`
--

INSERT INTO `enrollment_subjects` (`id`, `enrollment_id`, `class_schedule_id`, `final_grade`, `remarks`) VALUES
(34, 1, 1, NULL, NULL),
(35, 1, 2, NULL, NULL),
(36, 1, 3, NULL, NULL),
(37, 1, 4, NULL, NULL),
(38, 1, 5, NULL, NULL),
(39, 1, 6, NULL, NULL),
(40, 1, 7, NULL, NULL),
(41, 1, 8, NULL, NULL),
(42, 2, 9, NULL, NULL),
(43, 2, 10, NULL, NULL),
(44, 2, 11, NULL, NULL),
(45, 2, 12, NULL, NULL),
(46, 2, 13, NULL, NULL),
(47, 2, 14, NULL, NULL),
(48, 2, 15, NULL, NULL),
(49, 2, 16, NULL, NULL),
(50, 3, 1, NULL, NULL),
(51, 3, 2, NULL, NULL),
(52, 3, 3, NULL, NULL),
(53, 3, 4, NULL, NULL),
(54, 3, 5, NULL, NULL),
(55, 3, 6, NULL, NULL),
(56, 3, 7, NULL, NULL),
(57, 3, 8, NULL, NULL),
(58, 4, 9, NULL, NULL),
(59, 4, 10, NULL, NULL),
(60, 4, 11, NULL, NULL),
(61, 4, 12, NULL, NULL),
(62, 4, 13, NULL, NULL),
(63, 4, 14, NULL, NULL),
(64, 4, 15, NULL, NULL),
(65, 4, 16, NULL, NULL),
(66, 6, 9, NULL, NULL),
(67, 6, 10, NULL, NULL),
(68, 6, 11, NULL, NULL),
(69, 6, 12, NULL, NULL),
(70, 6, 13, NULL, NULL),
(71, 6, 14, NULL, NULL),
(72, 6, 15, NULL, NULL),
(73, 6, 16, NULL, NULL),
(74, 5, 1, NULL, NULL),
(75, 5, 2, NULL, NULL),
(76, 5, 3, NULL, NULL),
(77, 5, 4, NULL, NULL),
(78, 5, 5, NULL, NULL),
(79, 5, 6, NULL, NULL),
(80, 5, 7, NULL, NULL),
(81, 5, 8, NULL, NULL),
(82, 8, 9, NULL, NULL),
(83, 8, 10, NULL, NULL),
(84, 8, 11, NULL, NULL),
(85, 8, 12, NULL, NULL),
(86, 8, 13, NULL, NULL),
(87, 8, 14, NULL, NULL),
(88, 8, 15, NULL, NULL),
(89, 8, 16, NULL, NULL),
(90, 7, 1, NULL, NULL),
(91, 7, 2, NULL, NULL),
(92, 7, 3, NULL, NULL),
(93, 7, 4, NULL, NULL),
(94, 7, 5, NULL, NULL),
(95, 7, 6, NULL, NULL),
(96, 7, 7, NULL, NULL),
(97, 7, 8, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `student_no` varchar(50) NOT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `middlename` varchar(100) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `contact_no` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `student_no`, `firstname`, `lastname`, `middlename`, `birthdate`, `gender`, `address`, `contact_no`, `email`, `course_id`, `date_created`) VALUES
(1, '0000001', 'Reginald', 'Cano', 'Amolo', '2004-05-11', 'Male', 'Brgy. Combado, Maasin City, Southern Leyte', '09677701376', 'lowbattery224@gmail.com', 1, '2025-12-07 07:17:39'),
(2, '0000002', 'Isaach', 'Gañolo', NULL, '2005-07-02', 'Male', 'Brgy. Mantahan, Maasin City, Southern Leyte', '09357812645', 'gañoloisaach@gmail.com', 1, '2025-12-08 08:02:05'),
(3, '0000003', 'Reshiram', 'Kano', 'Cantano', '2004-05-20', 'Male', 'Brgy. Tagnipa, Maasin City, Southern Leyte', '09653857612', 'reshiram@gmail.com', 2, '2025-12-08 08:02:05'),
(4, '0000004', 'Megumi', 'Fushiguro', 'Zenin', '2005-12-24', NULL, 'Brgy. Tunga-Tunga, Maasin City, Southern Leyte', '09837619035', 'mahoraga123@gmail.com', 2, '2025-12-08 11:11:27');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `subject_code` varchar(50) NOT NULL,
  `subject_name` varchar(200) NOT NULL,
  `units` int(11) DEFAULT 3,
  `course_id` int(11) DEFAULT NULL,
  `year_level` int(11) DEFAULT NULL,
  `semester` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `units`, `course_id`, `year_level`, `semester`) VALUES
(1, 'IT101', 'Introduction to Computing', 3, 1, 1, '1st Semester'),
(2, 'IT102', 'Computer Programming 1', 3, 1, 1, '1st Semester'),
(3, 'GE101', 'Purposive Communication', 3, 1, 1, '1st Semester'),
(4, 'GE102', 'Mathematics in the Modern World', 3, 1, 1, '1st Semester'),
(5, 'PE101', 'Physical Education 1', 2, 1, 1, '1st Semester'),
(6, 'IT103', 'Computer Programming 2', 3, 1, 1, '1st Semester'),
(7, 'IT104', 'Introduction to Human-Computer Interaction', 3, 1, 1, '1st Semester'),
(8, 'GE103', 'Understanding the Self', 3, 1, 1, '1st Semester'),
(9, 'GE104', 'Science, Technology, and Society', 3, 1, 1, '2nd Semester'),
(10, 'PE102', 'Physical Education 2', 2, 1, 1, '2nd Semester'),
(11, 'MED150', 'Digital Media', 3, 1, 1, '2nd Semester'),
(12, 'MAT115', 'Statistics Lab', 3, 1, 1, '2nd Semester'),
(13, 'LIT103', 'World Literature', 3, 1, 1, '2nd Semester'),
(14, 'IT105', 'Data Structures and Algorithms', 3, 1, 1, '2nd Semester'),
(15, 'ART101', 'History of Art', 3, 1, 1, '2nd Semester'),
(16, 'PHY105', 'Advanced Physics', 3, 1, 1, '2nd Semester');

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contact_no` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`id`, `firstname`, `lastname`, `email`, `contact_no`) VALUES
(1, 'Izaya', 'Kano', 'Izaya@school.edu', '09171234567'),
(2, 'Ichigo', 'Kurosaki', 'IchiKuro@school.edu', '09281234567'),
(3, 'Luffy', 'Monkey', 'pirateKing@school.edu', '09391234567'),
(4, 'Light', 'Yagami', 'yagamilight@gmail.com', '09273850192'),
(5, 'Gintoki', 'Sakata', 'sakata02@gmail.com', '09224578201'),
(6, 'Mikasa', 'Ackerman', 'mikasaYeager@gmail.com', '09123875922');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `class_schedules_ibfk_1` (`subject_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `course_code` (`course_code`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `enrollment_subjects`
--
ALTER TABLE `enrollment_subjects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `enrollment_id` (`enrollment_id`),
  ADD KEY `class_schedule_id` (`class_schedule_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_no` (`student_no`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `class_schedules`
--
ALTER TABLE `class_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `enrollment_subjects`
--
ALTER TABLE `enrollment_subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `class_schedules`
--
ALTER TABLE `class_schedules`
  ADD CONSTRAINT `class_schedules_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `class_schedules_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`);

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);

--
-- Constraints for table `enrollment_subjects`
--
ALTER TABLE `enrollment_subjects`
  ADD CONSTRAINT `enrollment_subjects_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`id`),
  ADD CONSTRAINT `enrollment_subjects_ibfk_2` FOREIGN KEY (`class_schedule_id`) REFERENCES `class_schedules` (`id`);

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
