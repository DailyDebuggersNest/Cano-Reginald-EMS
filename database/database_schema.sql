-- Database: school_db21
-- Simplified schema with: students, programs, curriculum, schedules
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS school_db21;
USE school_db21;

-- Table: programs
-- Contains academic programs (e.g., BSIT, BSCS)
CREATE TABLE IF NOT EXISTS programs (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    program_code VARCHAR(50) NOT NULL UNIQUE,
    program_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: curriculum
-- Contains courses/subjects for each program, year level, and semester
CREATE TABLE IF NOT EXISTS curriculum (
    curriculum_id INT PRIMARY KEY AUTO_INCREMENT,
    program_id INT NOT NULL,
    course_code VARCHAR(50) NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    year_level INT NOT NULL,
    semester INT NOT NULL,
    units INT DEFAULT 3,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE CASCADE,
    INDEX idx_program_year_sem (program_id, year_level, semester)
);

-- Table: students
-- Contains student information
CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    program_id INT,
    year_level INT DEFAULT 1,
    status ENUM('Active', 'Inactive', 'Graduated') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE SET NULL,
    INDEX idx_program (program_id),
    INDEX idx_status (status)
);

-- Table: schedules
-- Contains class schedules for courses (day, time, room, instructor)
CREATE TABLE IF NOT EXISTS schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    curriculum_id INT NOT NULL,
    program_id INT NOT NULL,
    year_level INT NOT NULL,
    semester INT NOT NULL,
    day_of_week ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room VARCHAR(50),
    instructor VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE CASCADE,
    INDEX idx_curriculum (curriculum_id),
    INDEX idx_program (program_id)
);

-- Table: enrollments
-- Tracks student enrollment in specific courses with midterm and final grades
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    curriculum_id INT NOT NULL,
    academic_year VARCHAR(20) NOT NULL,
    midterm_grade DECIMAL(3,2),
    final_grade DECIMAL(3,2),
    status ENUM('Enrolled', 'Completed', 'Dropped', 'Failed') DEFAULT 'Enrolled',
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id) ON DELETE CASCADE,
    INDEX idx_student_year (student_id, academic_year),
    UNIQUE KEY unique_enrollment (student_id, curriculum_id, academic_year)
);
