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
- **Add Student**: Create new student profile (enrollment is separate)
- **Enroll Student**: Enroll student in courses with conflict detection
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
- **Auto Status**: Automatically sets Passed/Failed status based on final grade
- **GWA Calculation**: Automatic General Weighted Average computation
- **Grade Status**: Visual indicators (Excellent, Good, Average, Pass, Fail)
- **Enrollment Status**: Shows Enrolled, Passed, or Dropped

### UI/UX
- **Mobile-Responsive Design**: Fully responsive layout for all screen sizes
- **Hamburger Menu**: Mobile navigation with slide-down menu
- **Toast Notifications**: Success/error/warning/info messages with auto-dismiss
- **Confirmation Modals**: Modal overlay for destructive actions (Drop Student)
- **Loading Spinners**: Full-screen spinner for form submissions
- **Consistent Button Styles**: Unified design system across all pages
- **Status Badges**: Color-coded status indicators
- **Pagination Info**: Shows "Showing X-Y of Z" for student lists
- **Financial Module**: Track tuition, miscellaneous fees, and payment history per student.


---

## Project Structure

```
student_system21/
├── index.php                 # Main student list & curriculum view
├── README.md                 # This documentation
├── .gitignore                # Git ignore rules
│
├── pages/                    # PHP page files
│   ├── add_student.php       # Add new student form
│   ├── drop_student.php      # Drop student confirmation
│   ├── enroll_student.php    # Enroll student in courses (NEW)
│   ├── edit_student.php      # Edit student information
│   ├── edit_enrollment.php   # Edit student enrollment
│   ├── edit_grades.php       # Grade entry form
│   ├── student_personal.php  # Student personal information
│   ├── student_finance.php   # Student account & payment records
│   └── student_schedule_grades.php # Grades & Schedule View
│
├── config/                   # Configuration files
│   ├── database.php          # Database connection (singleton, error logging)
│   ├── db_helpers.php        # Database helpers (caching, transactions)
│   ├── finance_helpers.php   # Financial calculation helpers
│   └── schedule_validator.php # Conflict prevention validators
│
├── api/                      # AJAX Endpoints
│   ├── get_class_details.php # Fetch class roster for modals
│   └── dashboard_stats.php   # Data source for dashboard charts
│
├── css/                      # Stylesheets
│   ├── common.css            # Shared styles, typography, variables
│   ├── index.css             # Index page specific styles
│   └── details.css           # Detail pages styles
│
├── js/                       # JavaScript files
│   └── app.js                # Form validation, debouncing, utilities
│
├── logs/                     # Error logs (auto-generated)
│   └── .gitkeep              # Placeholder for git
│
├── tools/                    # Utility Scripts
│   └── debug/                # Debugging and verification tools
│       ├── check_schema.php
│       └── check_enrollments.php
│
└── database/                 # SQL files
    ├── database_schema.sql   # Table definitions with indexes
    ├── sample_data.sql       # Sample data for testing
    ├── migration_schedule_conflicts.sql  # Conflict prevention migration (NEW)
    └── run_migration.php     # Migration runner script (NEW)
```

---

## Database Schema

### Tables

### Tables Reference

#### 1. Core Data

**`students`**
| Column | Type | Description |
|--------|------|-------------|
| `student_id` | INT (PK) | Unique identifier |
| `student_number` | VARCHAR | Unique student ID number |
| `first_name` | VARCHAR | First name |
| `last_name` | VARCHAR | Last name |
| `program_id` | INT (FK) | Enrolled program |
| `year_level` | INT | Current year level (1-4) |
| `status` | ENUM | Active, Inactive, Graduated |
| `academic_standing` | VARCHAR | e.g. Good, Warning, Probation |

**`programs`**
| Column | Type | Description |
|--------|------|-------------|
| `program_id` | INT (PK) | Unique identifier |
| `program_code` | VARCHAR | Short code (e.g. BSIT) |
| `program_name` | VARCHAR | Full name |

**`teachers`**
| Column | Type | Description |
|--------|------|-------------|
| `teacher_id` | INT (PK) | Unique identifier |
| `first_name` | VARCHAR | First name |
| `last_name` | VARCHAR | Last name |
| `department` | VARCHAR | Faculty department |
| `status` | ENUM | Active, Inactive, On Leave |

#### 2. Academic Structure

**`curriculum`**
| Column | Type | Description |
|--------|------|-------------|
| `curriculum_id` | INT (PK) | Unique identifier |
| `program_id` | INT (FK) | Related program |
| `course_code` | VARCHAR | Subject code (e.g. IT101) |
| `course_name` | VARCHAR | Subject description |
| `units` | INT | Credit units (default 3) |
| `year_level` | INT | Year taken (1-4) |
| `semester` | INT | Semester taken (1-2) |
| `prerequisite_id` | INT (FK) | Required previous course |

**`schedules`**
| Column | Type | Description |
|--------|------|-------------|
| `schedule_id` | INT (PK) | Unique identifier |
| `curriculum_id` | INT (FK) | Related course |
| `teacher_id` | INT (FK) | Assigned instructor |
| `day_of_week` | ENUM | Mon-Sun |
| `start_time` | TIME | Class start |
| `end_time` | TIME | Class end |
| `room` | VARCHAR | Classroom location |
| `enrolled_count` | INT | Current student count |

**`enrollments`**
| Column | Type | Description |
|--------|------|-------------|
| `enrollment_id` | INT (PK) | Unique identifier |
| `student_id` | INT (FK) | Enrolled student |
| `curriculum_id` | INT (FK) | Enrolled course |
| `academic_year` | VARCHAR | e.g. "2025-2026" |
| `midterm_grade` | DECIMAL | 1.00 - 5.00 |
| `final_grade` | DECIMAL | 1.00 - 5.00 |
| `status` | ENUM | Enrolled, Passed, Failed |

**`semester_status`**
| Column | Type | Description |
|--------|------|-------------|
| `status_id` | INT (PK) | Unique identifier |
| `student_id` | INT (FK) | Student |
| `academic_year` | VARCHAR | Academic Year |
| `semester` | INT | Semester number |
| `gpa` | DECIMAL | Term GPA |
| `status` | ENUM | In Progress, Completed |

#### 3. Financial Module

**`fees`**
| Column | Type | Description |
|--------|------|-------------|
| `fee_id` | INT (PK) | Unique identifier |
| `code` | VARCHAR | Fee code |
| `amount` | DECIMAL | Amount in PHP |
| `type` | ENUM | 'per_unit' or 'fixed' |

**`program_tuition_rates`**
| Column | Type | Description |
|--------|------|-------------|
| `rate_id` | INT (PK) | Unique identifier |
| `program_id` | INT (FK) | Program |
| `tuition_per_unit` | DECIMAL | Cost per unit |
| `lab_fee` | DECIMAL | Lab fee amount |
| `effective_date` | DATE | Validity start |

**`payments`**
| Column | Type | Description |
|--------|------|-------------|
| `payment_id` | INT (PK) | Unique identifier |
| `student_id` | INT (FK) | Payer |
| `amount` | DECIMAL | Amount paid |
| `payment_date` | TIMESTAMP | Date of payment |
| `academic_year` | VARCHAR | Term applied to |
| `semester` | INT | Semester applied to |

**`term_overpayments`**
| Column | Type | Description |
|--------|------|-------------|
| `overpayment_id` | INT (PK) | Unique identifier |
| `student_id` | INT (FK) | Student |
| `amount` | DECIMAL | Excess amount |
| `is_applied` | BOOL | If used in next term |

**`scholarships`**
| Column | Type | Description |
|--------|------|-------------|
| `scholarship_id` | INT (PK) | Unique identifier |
| `name` | VARCHAR | Scholarship name |
| `discount_type` | ENUM | 'percentage' or 'fixed' |
| `discount_value` | DECIMAL | Amount/Percent off |

**`student_scholarships`**
| Column | Type | Description |
|--------|------|-------------|
| `student_id` | INT (FK) | Student |
| `scholarship_id` | INT (FK) | Scholarship |
| `academic_year` | VARCHAR | Term active |
| `semester` | INT | Semester active |

#### 4. System & Configuration

**`system_settings`**
| Column | Type | Description |
|--------|------|-------------|
| `setting_key` | VARCHAR | Config key name |
| `setting_value` | VARCHAR | Config value |

**`academic_standings`**
| Column | Type | Description |
|--------|------|-------------|
| `student_id` | INT (FK) | Student |
| `academic_year` | VARCHAR | Term |
| `standing` | ENUM | Dean's List, Probation, etc. |
| `gpa_at_time` | DECIMAL | GPA snapshot |

### Key Relationships
- `students.program_id` → `programs.program_id`
- `schedules.curriculum_id` → `curriculum.curriculum_id`
- `enrollments.student_id` → `students.student_id`
- `enrollments.curriculum_id` → `curriculum.curriculum_id`
- `student_scholarships.scholarship_id` → `scholarships.scholarship_id`

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
- Auto-sets status based on final grade (≤3.00 = Passed, 5.00 = Failed)
- Batch save all grades at once

### student_personal.php
- Basic info: Student number, gender, birthdate, contact
- Contact info: Email, phone, address
- Academic info: Program, year level, enrollment date, status

### student_schedule_grades.php
- Combined Schedule and Grades view
- Filter by year level and semester
- **Schedule Tab**: Course details, meeting times, room, instructor
- **Grades Tab**: Midterm/Final grades, GWA calculation, status


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
- **Pagination**: 10 students per page
- **Search**: Real-time filtering in header
- **Enrollment System Refactor**: Separated "Add Student" from enrollment. Added specific enrollment page with conflict checking.

### Enrollment & Conflicts
- ✅ **New Enrollment Page**: `enroll_student.php` handles course selection by year/semester.
- ✅ **Conflict Detection**: Prevents enrollment if schedules overlap.
- ✅ **Manual Enrollment**: "Enroll" action added to student list.

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

### Program-Specific Tuition Rates (January 31, 2026)
- ✅ **Program Tuition Rates Table**: New `program_tuition_rates` table with per-program tuition and lab fees
- ✅ **Differentiated Tuition**: Programs now have specific rates:
  | Program | Tuition/Unit | Lab Fee |
  |---------|-------------|---------|
  | BSCS | ₱1,350 | ₱4,000 |
  | BSIT | ₱1,200 | ₱3,500 |
  | BSIS | ₱1,100 | ₱2,500 |
  | BSBA | ₱900 | ₱1,500 |
  | BSE | ₱750 | ₱1,000 |
- ✅ **Helper Functions**: `getProgramTuitionRate()`, `getStudentProgramId()` for retrieving program-specific rates

### Overpayment Carry-Forward System (January 31, 2026)
- ✅ **Term Overpayments Table**: New `term_overpayments` table for tracking credit carry-forward
- ✅ **Automatic Credit Application**: Overpayments from previous terms automatically apply to subsequent term assessments
- ✅ **Running Balance Tracking**: System tracks running credit balance across all terms chronologically
- ✅ **Visual Indicators**: 
  - "💰 Credit Applied (from previous term overpayment)" row in assessment breakdown
  - "→ Credit to Next Term" shows excess payment available for future terms
  - Balance card displays available credits
- ✅ **Helper Functions**: 
  - `calculateAllTermsWithCarryForward()` - Main calculation engine
  - `getAvailableOverpaymentCredit()` - Gets unapplied credits
  - `recordOverpayment()` / `applyOverpaymentCredit()` - Credit management

### Dashboard UI/UX Improvements (January 31, 2026)
- ✅ **Modern Header**: Gradient header with improved typography
- ✅ **Pill-Style Tabs**: Rounded, modern tab navigation
- ✅ **Enhanced Charts**: Softer color palette, better tooltips, improved legends
- ✅ **Data Tables**: Zebra striping, sticky headers, hover effects
- ✅ **Revenue Summary**: Grid layout with better visual hierarchy
- ✅ **Mobile Responsiveness**: Better layout on smaller screens

### Future-Proof Academic Year (February 2, 2026)
- ✅ **Dynamic Year Generation**: `add_student.php` now automatically generates the current academic year and the next 2 years. No manual code updates required.
- ✅ **Smart Filtering**: Schedule/Grades filter logic (`db_helpers.php`) updated to seamlessly combine historical enrollment records with current year logic.

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
   define('DB_HOST', 'localhost');
   define('DB_USER', 'root');
   define('DB_PASS', '');
   define('DB_NAME', 'school_db21');
   ```

6. **Access Application**
   ```
   http://localhost/student_system21/index.php
   ```

---

## Transferring Project to Another PC

### Method 1: Full Project Export (Recommended)

#### On the Source PC:

1. **Export the Database**
   ```bash
   # Open Command Prompt/Terminal
   cd C:\xampp\mysql\bin
   
   # Export database to SQL file
   mysqldump -u root school_db21 > C:\xampp\htdocs\student_system21\database\complete_database.sql
   ```
   
   Or use phpMyAdmin:
   - Open `http://localhost/phpmyadmin`
   - Select `school_db21` database
   - Click "Export" tab
   - Choose "Quick" export method
   - Click "Go" and save the `.sql` file

2. **Copy the Project Folder**
   ```
   Copy entire folder: C:\xampp\htdocs\student_system21\
   ```
   
   You can:
   - Compress to ZIP file for easier transfer
   - Copy to USB drive
   - Upload to cloud storage (Google Drive, Dropbox, etc.)
   - Use Git repository

#### On the Destination PC:

1. **Install XAMPP**
   - Download from: https://www.apachefriends.org/
   - Install with Apache and MySQL components
   - Start Apache and MySQL from XAMPP Control Panel

2. **Copy Project Files**
   ```
   Paste folder to: C:\xampp\htdocs\student_system21\
   ```

3. **Create Database**
   ```sql
   -- In phpMyAdmin or MySQL CLI:
   CREATE DATABASE school_db21;
   ```

4. **Import Database**
   
   Using Command Line:
   ```bash
   cd C:\xampp\mysql\bin
   mysql -u root school_db21 < C:\xampp\htdocs\student_system21\database\complete_database.sql
   ```
   
   Or using phpMyAdmin:
   - Open `http://localhost/phpmyadmin`
   - Select `school_db21` database
   - Click "Import" tab
   - Choose the exported `.sql` file
   - Click "Go"

5. **Verify Configuration**
   
   Check `config/database.php` matches your setup:
   ```php
   define('DB_HOST', 'localhost');
   define('DB_USER', 'root');
   define('DB_PASS', '');  // Empty for default XAMPP
   define('DB_NAME', 'school_db21');
   ```

6. **Test the Application**
   ```
   http://localhost/student_system21/index.php
   ```

### Method 2: Fresh Install with Sample Data

If you don't need to preserve existing data:

1. Copy project folder to `C:\xampp\htdocs\student_system21\`
2. Create database: `CREATE DATABASE school_db21;`
3. Import schema: `database/schema.sql`
4. Import sample data: `database/data.sql`
5. Run migrations: `database/migration_program_tuition.sql`

### Method 3: Using Git (For Development)

```bash
# On source PC - initialize and push
cd C:\xampp\htdocs\student_system21
git init
git add .
git commit -m "Initial commit"
git remote add origin <your-repo-url>
git push -u origin main

# On destination PC - clone and setup
cd C:\xampp\htdocs
git clone <your-repo-url> student_system21
# Then import database as described above
```

### Troubleshooting Transfer Issues

| Issue | Solution |
|-------|----------|
| "Unknown database" error | Create the database first: `CREATE DATABASE school_db21;` |
| "Access denied" error | Check DB_USER and DB_PASS in `config/database.php` |
| Blank page | Check Apache error logs: `C:\xampp\apache\logs\error.log` |
| Missing tables | Import the schema.sql file first, then data.sql |
| Port conflict | Change Apache port in XAMPP settings if 80 is in use |

### Files to Include in Transfer

```
student_system21/
├── index.php
├── README.md
├── pages/           ← All PHP pages
├── config/          ← Database and helper configs
├── api/             ← API endpoints
├── css/             ← Stylesheets
├── js/              ← JavaScript files
├── database/        ← SQL files (schema, data, migrations)
│   ├── schema.sql
│   ├── data.sql
│   ├── migration_program_tuition.sql
│   └── complete_database.sql  ← Full export (if available)
└── logs/            ← Can be empty (auto-generated)
```

---

## License

This project is for educational purposes.
