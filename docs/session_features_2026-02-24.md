# Session Features Documentation
**Date:** February 24, 2026

---

## 1. Smart Schedule Suggestions (enrollment.php)

### 1.1 Inline Autocomplete
- **Trigger:** Type in the "Schedule Code" input field
- **Behavior:** Shows dropdown with matching schedules (up to 8 results)
- **Filters:** Automatically filters by:
  - Student's confirmed program
  - Student's year level
  - Semester from term code
- **Search:** Matches against schedule ID, course code, or course name
- **Selection:** Click any result to auto-fill and lookup the schedule

### 1.2 Toggle Schedule List
- **Button:** "Show All Schedules" / "Hide Schedules"
- **Displays:** Full list of available schedules for the student's criteria
- **Information shown:**
  - Schedule ID
  - Course Code & Name
  - Units
  - Day/Time
  - Room
  - Teacher
  - Available slots (with "FULL" indicator)
- **Selection:** Click any schedule to auto-fill and lookup

---

## 2. Bulk Enrollment Workflow

### 2.1 Pending Subjects List
- **"Add Subject" button:** Adds schedule to a pending list (yellow box)
- **Does NOT immediately enroll** - just queues for review
- **Features:**
  - Shows course code, name, and units
  - "Remove" button for each pending item
  - Pending list appears after adding first subject

### 2.2 Enroll Student Button
- **Trigger:** Appears when pending list has items
- **Opens:** Confirmation modal for final review

### 2.3 Confirmation Modal
Displays all enrollment details for verification:

| Field | Description |
|-------|-------------|
| **Term Code** | Shows input code → converted format (e.g., "251 → 2025-2026 (1st Semester)") |
| **Student** | Student number and full name |
| **Program** | Selected program code/name |
| **Subjects** | List of all pending subjects with day/time/units |

- **"Cancel"** - Returns to form
- **"Confirm Enrollment"** - Processes bulk enrollment

### 2.4 Bulk Enrollment Backend
**Endpoint:** `enrollment.php?action=bulk_enroll`

**Updates:**
1. Student's `program_id` in students table
2. Student's `current_semester` in students table
3. Creates enrollment records for each schedule
4. Increments `enrolled_count` for each schedule

**Features:**
- Database transaction for data integrity
- Capacity validation per schedule
- Duplicate enrollment check
- Returns summary of enrolled courses and any errors

---

## 3. Term Code Format

**Format:** 3-digit code `YYS`
- `YY` = Year (e.g., 25 = 2025)
- `S` = Semester (0 = Summer, 1 = 1st Sem, 2 = 2nd Sem)

**Examples:**
| Code | Academic Year | Semester |
|------|---------------|----------|
| 251 | 2025-2026 | 1st Semester |
| 252 | 2025-2026 | 2nd Semester |
| 260 | 2026-2027 | Summer |

**Validation:**
- Must be exactly 3 digits
- Cannot be past academic years
- Cannot exceed 3 years in advance

---

## 4. Database Changes

### 4.1 Student Updates on Enrollment
When bulk enrollment completes:
```sql
UPDATE students 
SET program_id = ?, current_semester = ? 
WHERE student_id = ?
```

### 4.2 Enrollment Record Creation
```sql
INSERT INTO enrollments (student_id, curriculum_id, academic_year, status) 
VALUES (?, ?, ?, 'Enrolled')
```

---

## 5. Test Data Created

**Student:** Test Dummy Student
- **Student Number:** 2026-00025
- **Student ID:** 32
- **Program:** BSIT (Bachelor of Science in Information Technology)
- **Year Level:** 1
- **Semester:** 1st

**Enrolled Subjects (6 courses, 18 units):**

| Course Code | Course Name | Units |
|-------------|-------------|-------|
| IT 111 | Introduction to Information Technology | 3 |
| IT 112 | Computer Fundamentals | 3 |
| IT 113 | Programming Fundamentals I | 3 |
| IT 114 | Mathematics for IT | 3 |
| IT 115 | Computer Ethics | 3 |
| IT 116 | English for IT | 3 |

**Finance Verification:**
- Tuition Rate: ₱1,200.00/unit
- Total Tuition: 18 × ₱1,200.00 = **₱21,600.00** ✓

---

## 6. Files Modified

| File | Changes |
|------|---------|
| `pages/enrollment.php` | Added schedule autocomplete, toggle list, pending subjects, bulk enrollment, confirmation modal |

---

## 7. API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `?action=lookup_student&student_number=X` | GET | Lookup student by number |
| `?action=lookup_schedule&schedule_id=X` | GET | Lookup schedule details |
| `?action=get_schedule_suggestions&program_id=X&year_level=X&semester=X&search=X` | GET | Get filtered schedules |
| `?action=bulk_enroll` | POST (JSON) | Bulk enroll student in multiple schedules |
| `?action=get_recent_students` | GET | Get 10 most recent students |

### Bulk Enroll Request Body
```json
{
  "student_id": 32,
  "program_id": 1,
  "academic_year": "2025-2026",
  "semester": 1,
  "schedule_ids": [1, 3, 5, 7, 9, 11]
}
```

### Bulk Enroll Response
```json
{
  "success": true,
  "message": "Successfully enrolled in 6 course(s)",
  "enrolled": ["IT 111 - Intro to IT", "..."],
  "errors": []
}
```
