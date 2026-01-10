<?php
/**
 * Script: populate_enrollment_and_subjects.php
 * Purpose: Populate `enrollment` and `subjects_enrolled` for existing students.
 * Usage (from PowerShell in project root):
 *   php .\scripts\populate_enrollment_and_subjects.php
 * Notes:
 * - We derive the current academic semester from the server date (Jan-Jun => sem1, Jul-Dec => sem2).
 * - For each student, this will insert enrollment rows for year 1 up to `student.year_level`.
 * - For years < current student year, both semesters are inserted and marked as `Completed`.
 * - For the student's current year, semesters up to `currentSemester` are inserted; the current semester is marked `Enrolled`.
 * - For each enrollment row, this script will insert `subjects_enrolled` rows linking that student to all courses
 *   in the student's curriculum for the matching year_level and semester if such a subjects_enrolled row doesn't already exist.
 */

require_once __DIR__ . '/../config/database.php';

$conn = getDBConnection();
if (!$conn) {
    echo "Unable to connect to DB\n";
    exit(1);
}

// determine current semester based on current month
$month = intval(date('n'));
$currentSemester = ($month >= 1 && $month <= 6) ? 1 : 2;

echo "Running population script (current semester = $currentSemester)\n";

// Prepared statements
$enroll_check = $conn->prepare("SELECT enrollment_id FROM enrollment WHERE student_id = ? AND year_level = ? AND semester = ? LIMIT 1");
$enroll_insert = $conn->prepare("INSERT INTO enrollment (student_id, curriculum_id, year_level, semester, status, enrolled_at) VALUES (?, ?, ?, ?, ?, NOW())");

$subjects_check = $conn->prepare("SELECT id FROM subjects_enrolled WHERE student_id = ? AND course_id = ? AND year_level = ? AND semester = ? LIMIT 1");
$subjects_insert = $conn->prepare("INSERT INTO subjects_enrolled (student_id, course_id, year_level, semester, grade, date_taken) VALUES (?, ?, ?, ?, NULL, NOW())");

// Query all students
$stu_res = $conn->query("SELECT student_id, curriculum_id, year_level, created_at FROM student");
if (!$stu_res) {
    echo "No students found or query failed.\n";
    exit(1);
}

$totalEnrollInserted = 0;
$totalSubjectsInserted = 0;

while ($stu = $stu_res->fetch_assoc()) {
    $student_id = intval($stu['student_id']);
    $curriculum_id = intval($stu['curriculum_id']);
    $stud_year_level = intval($stu['year_level']);

    if ($stud_year_level < 1) $stud_year_level = 1;

    // For each year from 1..stud_year_level
    for ($y = 1; $y <= $stud_year_level; $y++) {
        // decide semester upper bound for this year
        $sem_max = ($y < $stud_year_level) ? 2 : $currentSemester;

        for ($s = 1; $s <= $sem_max; $s++) {
            // skip if enrollment exists
            $enroll_check->bind_param('iii', $student_id, $y, $s);
            $enroll_check->execute();
            $enr_check_res = $enroll_check->get_result();
            if ($enr_check_res && $enr_check_res->num_rows > 0) {
                // already exists
            } else {
                // determine status
                if ($y < $stud_year_level || ($y == $stud_year_level && $s < $currentSemester)) {
                    $status = 'Completed';
                } elseif ($y == $stud_year_level && $s == $currentSemester) {
                    $status = 'Enrolled';
                } else {
                    $status = 'Enrolled';
                }
                $enroll_insert->bind_param('iiiss', $student_id, $curriculum_id, $y, $s, $status);
                if ($enroll_insert->execute()) {
                    $totalEnrollInserted++;
                }
            }

            // Now connect courses for this curriculum/year/semester to subjects_enrolled
            if ($curriculum_id > 0) {
                $courses_q = $conn->prepare("SELECT course_id FROM courses WHERE curriculum_id = ? AND year_level = ? AND semester = ?");
                $courses_q->bind_param('iii', $curriculum_id, $y, $s);
                $courses_q->execute();
                $courses_res = $courses_q->get_result();
                if ($courses_res) {
                    while ($course = $courses_res->fetch_assoc()) {
                        $course_id = intval($course['course_id']);
                        $subjects_check->bind_param('iiii', $student_id, $course_id, $y, $s);
                        $subjects_check->execute();
                        $sub_check_res = $subjects_check->get_result();
                        if ($sub_check_res && $sub_check_res->num_rows > 0) {
                            // already enrolled
                        } else {
                            $subjects_insert->bind_param('iiii', $student_id, $course_id, $y, $s);
                            if ($subjects_insert->execute()) {
                                $totalSubjectsInserted++;
                            }
                        }
                    }
                }
                $courses_q->close();
            }
        }
    }
}

echo "Done. Enrollments inserted: $totalEnrollInserted; subjects_enrolled inserted: $totalSubjectsInserted\n";

$enroll_check->close();
$enroll_insert->close();
$subjects_check->close();
$subjects_insert->close();
$conn->close();

exit(0);

?>