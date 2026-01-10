# Student Management System

A PHP-based web application for managing student records, enrollments, schedules, and grades.

## Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Pages Overview](#pages-overview)
- [Recent Changes](#recent-changes)
- [Setup Instructions](#setup-instructions)

---

## Features

### Student Management
- **View Students**: Paginated list of all students (10 per page)
- **Search**: Search students by name or student number
- **Sort**: Sort by last name, first name, or student number (ascending/descending)
- **Filter by Program**: Filter student list by program (BSIT, BSCS, BSIS, BSBA, BSE)
- **Add Student**: Create new student with auto-enrollment in courses
- **Edit Student**: Update student personal and academic information
- **Drop Student**: Remove student with confirmation page and cascade delete of enrollments

### Program & Curriculum
- **5 Programs**: BSIT, BSCS, BSIS, BSBA, BSE
- **Standardized Curriculum**: 24 units per semester (8 courses × 3 units each)
- **View Curriculum**: Filter by program, year level, and semester
- **Pagination**: 15 courses per page

### Class Schedules
- **Schedule Format**: 2 meetings × 1.5 hours per 3-unit course
- **Teachers Table**: 53 instructors with contact information
- **Filter Schedules**: By year level and semester
- **Total Units Display**: Shows units enrolled per semester

### Grades
- **Grade Tracking**: View grades by year and semester
- **Grade Entry**: Enter/edit midterm and final grades (Philippine grading: 1.00-5.00)
- **Auto Status**: Automatically sets Completed/Failed status based on final grade
- **GWA Calculation**: Automatic General Weighted Average computation
- **Grade Status**: Visual indicators (Excellent, Good, Average, Pass, Fail)
- **Enrollment Status**: Shows Enrolled, Completed, or Dropped

### UI/UX
- **Mobile-Responsive Design**: Fully responsive layout for all screen sizes
- **Hamburger Menu**: Mobile navigation with slide-down menu
- **Toast Notifications**: Success/error/warning/info messages with auto-dismiss
- **Confirmation Modals**: Modal overlay for destructive actions (Drop Student)
- **Loading Spinners**: Full-screen spinner for form submissions
- **Consistent Button Styles**: Unified design system across all pages
- **Status Badges**: Color-coded status indicators
- **Pagination Info**: Shows "Showing X-Y of Z" for student lists

---

## Project Structure

```
student_system21/
├── index.php                 # Main student list & curriculum view
├── README.md                 # This documentation
│
├── pages/                    # PHP page files
│   ├── add_student.php       # Add new student form
│   ├── drop_student.php      # Drop student confirmation
│   ├── edit_student.php      # Edit student information
│   ├── edit_grades.php       # Grade entry form
│   ├── student_personal.php  # Student personal information
│   ├── student_schedules.php # Student class schedules
│   └── student_grades.php    # Student grades view
│
├── config/                   # Configuration files
│   ├── database.php          # Database connection settings
│   └── db_helpers.php        # Database helper functions
│
├── css/                      # Stylesheets
│   ├── common.css            # Shared styles & button system
│   ├── index.css             # Index page specific styles
│   └── details.css           # Detail pages styles
│
└── database/                 # SQL files
    ├── database_schema.sql   # Table definitions
    └── sample_data.sql       # Sample data for testing
```

---

## Database Schema

### Tables

| Table | Description |
|-------|-------------|
| `students` | Student personal information |
| `programs` | Academic programs (BSIT, BSCS, etc.) |
| `curriculum` | Courses for each program/year/semester |
| `schedules` | Class meeting times, rooms, and instructor |
| `enrollments` | Student course enrollments with grades |

### Key Relationships
- `students.program_id` → `programs.program_id`
- `curriculum.program_id` → `programs.program_id`
- `schedules.curriculum_id` → `curriculum.curriculum_id`
- `enrollments.student_id` → `students.student_id`
- `enrollments.curriculum_id` → `curriculum.curriculum_id`

### Curriculum Structure
- **Per Semester**: 8 courses × 3 units = 24 units
- **Per Year**: 2 semesters × 24 units = 48 units
- **4-Year Program**: 4 years × 48 units = 192 total units

---

## Pages Overview

### index.php (Main Page)
- Student list with search, sort, and pagination
- Curriculum view with program/year/semester filters
- Quick action buttons: Info, Schedule, Grades, Drop
- "+ Add Student" button

### add_student.php
- Form fields: Name, contact, address, enrollment info
- Auto-enrollment: Enrolls in 8 courses for selected year/semester
- Validation: Required fields, date formats

### drop_student.php
- Confirmation page with student details
- Warning about permanent deletion
- Cascading delete of enrollments

### edit_student.php
- Edit all student details (name, email, phone, address)
- Update program, year level, and status
- Student number is read-only
- Validation for required fields and email format

### edit_grades.php
- Enter midterm and final grades
- Philippine grading system (1.00 = highest, 5.00 = failed)
- Filter by year level and semester
- Auto-sets status based on final grade (≤3.00 = Completed, >3.00 = Failed)
- Batch save all grades at once

### student_personal.php
- Basic info: Student number, gender, birthdate, contact
- Contact info: Email, phone, address
- Academic info: Program, year level, enrollment date, status

### student_schedules.php
- Filter by year level and semester
- Table: Course code, name, day, time, room, instructor
- Grouped by course to avoid duplicate unit counting
- Total units badge

### student_grades.php
- Filter by year level and semester
- Table: Course code, name, units, grade, status
- GWA calculation (completed courses only)
- Color-coded grade indicators

---

## Recent Changes

### Curriculum Standardization
- ✅ Changed all PE courses from 2 units to 3 units
- ✅ All semesters now have exactly 8 courses × 3 units = 24 units
- ✅ Applied to all 5 programs (BSIT, BSCS, BSIS, BSBA, BSE)

### Schedule Updates
- ✅ All courses now have 2 meetings per week
- ✅ Each meeting is 1.5 hours (matching 3-unit format)
- ✅ Added second meeting times for previously single-meeting courses

### Teachers System
- ✅ Created `teachers` table with 53 instructors
- ✅ Linked schedules to teachers via `teacher_id` foreign key
- ✅ Removed redundant `instructor` text column from schedules
- ✅ Removed redundant columns: `program_id`, `year_level`, `semester` (already in curriculum)

### Student Management
- ✅ Add student form with auto-enrollment
- ✅ Edit student information page
- ✅ Drop student with confirmation page
- ✅ Program filter dropdown on student list
- ✅ Toast notifications for success/error messages
- ✅ Pagination for student list (10 per page)
- ✅ Search bar in header

### Grade Entry System
- ✅ New edit_grades.php page for entering grades
- ✅ Philippine grading system support (1.00-5.00)
- ✅ Auto-status based on final grade
- ✅ Batch grade entry with single save

### UI Improvements
- ✅ Consistent button design system in common.css
- ✅ Transparent backgrounds with colored borders
- ✅ Solid fill on hover
- ✅ Unified header structure across all detail pages
- ✅ Short program descriptions

### UI/UX Enhancements (January 2026)
- ✅ **Mobile-Responsive Design**: Responsive breakpoints for tablets and phones
- ✅ **Hamburger Menu**: Collapsible navigation on mobile devices
- ✅ **Confirmation Modals**: Modal overlay for Drop Student action
- ✅ **Loading Spinners**: Visual feedback during form submissions
- ✅ **Enhanced Toast Notifications**: Support for success, error, warning, info types
- ✅ **Improved Pagination**: Shows "Showing X-Y of Z students" info

### File Organization
- ✅ PHP pages moved to `pages/` folder
- ✅ Config files in `config/` folder
- ✅ SQL files in `database/` folder
- ✅ Updated all file paths and references

---

## Button Style Guide

| Class | Color | Use Case |
|-------|-------|----------|
| `.btn` | Gray | Default button |
| `.btn-primary` | Dark | Primary actions |
| `.btn-back` | Gray | Navigation back |
| `.btn-info` | Blue | View personal info |
| `.btn-schedule` | Green | View schedules |
| `.btn-grades` | Purple | View grades |
| `.btn-add` | Green | Add/create actions |
| `.btn-drop` | Red | Delete/danger actions |
| `.btn-cancel` | Gray | Cancel actions |
| `.btn-search` | Blue | Search actions |
| `.btn-edit` | Orange | Edit actions |

---

## UI Components

### Modal (Confirmation Dialog)
```html
<div class="modal-overlay" id="confirmModal">
    <div class="modal">
        <div class="modal-header">...</div>
        <div class="modal-body">...</div>
        <div class="modal-footer">...</div>
    </div>
</div>
```

### Loading Spinner
```html
<div class="spinner-overlay" id="loadingSpinner">
    <div class="spinner"></div>
</div>
```

### Toast Notifications
```html
<div class="toast toast-success" id="toast">
    <span class="toast-message">Message here</span>
    <button class="toast-close">&times;</button>
</div>
```
Types: `toast-success`, `toast-error`, `toast-warning`, `toast-info`

---

## Setup Instructions

### Requirements
- XAMPP (or similar PHP/MySQL environment)
- PHP 7.4+
- MySQL 5.7+

### Installation

1. **Clone/Copy Files**
   ```
   Copy all files to: C:\xampp\htdocs\student_system21\
   ```

2. **Create Database**
   ```sql
   CREATE DATABASE school_db21;
   ```

3. **Import Schema**
   ```
   Import: database/database_schema.sql
   ```

4. **Import Sample Data**
   ```
   Import: database/sample_data.sql
   ```

5. **Configure Database Connection**
   Edit `config/database.php`:
   ```php
   $host = 'localhost';
   $username = 'root';
   $password = '';
   $database = 'school_db21';
   ```

6. **Access Application**
   ```
   http://localhost/student_system21/index.php
   ```

---

## License

This project is for educational purposes.
