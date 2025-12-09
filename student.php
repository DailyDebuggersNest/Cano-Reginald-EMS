<?php
include 'database.php';

$studentId = isset($_GET['id']) ? intval($_GET['id']) : 0;

if ($studentId <= 0) {
    http_response_code(400);
    echo 'Invalid student.';
    exit;
}

$stmt = mysqli_prepare($conn, "
    SELECT s.*, c.course_code, c.course_name
    FROM students AS s
    LEFT JOIN courses AS c ON s.course_id = c.id
    WHERE s.id = ?
");

if (!$stmt) {
    echo 'Unable to prepare query.';
    exit;
}

mysqli_stmt_bind_param($stmt, 'i', $studentId);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);
$student = $result ? mysqli_fetch_assoc($result) : null;
mysqli_stmt_close($stmt);

$enrollments = [];
$enrollStmt = mysqli_prepare($conn, "
    SELECT e.id AS enrollment_id,
           e.school_year,
           e.semester,
           e.date_enrolled,
           c.course_code,
           c.course_name
    FROM enrollments AS e
    LEFT JOIN courses AS c ON e.course_id = c.id
    WHERE e.student_id = ?
    ORDER BY e.date_enrolled ASC
");

if ($enrollStmt) {
    mysqli_stmt_bind_param($enrollStmt, 'i', $studentId);
    mysqli_stmt_execute($enrollStmt);
    $enrollResult = mysqli_stmt_get_result($enrollStmt);
    if ($enrollResult) {
        while ($row = mysqli_fetch_assoc($enrollResult)) {
            $enrollments[] = $row;
        }
    }
    mysqli_stmt_close($enrollStmt);
}

$selectedEnrollmentId = isset($_GET['enrollment']) ? intval($_GET['enrollment']) : 0;
$classRows = [];

if ($selectedEnrollmentId > 0) {
    $classStmt = mysqli_prepare($conn, "
        SELECT subj.subject_code,
               subj.subject_name,
               subj.units,
               cs.room,
               cs.schedule_day,
               cs.schedule_time,
               cs.school_year,
               cs.semester,
               t.firstname AS teacher_firstname,
               t.lastname AS teacher_lastname,
               es.final_grade,
               es.remarks
        FROM enrollment_subjects AS es
        JOIN enrollments AS e ON es.enrollment_id = e.id AND e.student_id = ?
        JOIN class_schedules AS cs ON es.class_schedule_id = cs.id
        LEFT JOIN subjects AS subj ON cs.subject_id = subj.id
        LEFT JOIN teachers AS t ON cs.teacher_id = t.id
        WHERE es.enrollment_id = ?
        ORDER BY subj.subject_code
    ");

    if ($classStmt) {
        mysqli_stmt_bind_param($classStmt, 'ii', $studentId, $selectedEnrollmentId);
        mysqli_stmt_execute($classStmt);
        $classResult = mysqli_stmt_get_result($classStmt);
        if ($classResult) {
            while ($row = mysqli_fetch_assoc($classResult)) {
                $classRows[] = $row;
            }
        }
        mysqli_stmt_close($classStmt);
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details</title>
    <link rel="stylesheet" href="assets/student.css">
</head>
<body>
    <div class="page detail">
        <a class="back" href="index.php">&larr; Back to list</a>
        <?php if ($student): ?>
            <h1>Student Information</h1>
            <div class="detail-card">
                <p><strong>ID:</strong> <?= htmlspecialchars($student['id']) ?></p>
                <p><strong>Student Number:</strong> <?= htmlspecialchars($student['student_no']) ?></p>
                <p><strong>Name:</strong> <?= htmlspecialchars($student['lastname'] . ', ' . $student['firstname'] . ' ' . $student['middlename']) ?></p>
                <p><strong>Course:</strong> <?= htmlspecialchars(($student['course_code'] ?? 'N/A') . ' - ' . ($student['course_name'] ?? 'N/A')) ?></p>
                <p><strong>Address:</strong> <?= htmlspecialchars($student['address']) ?></p>   
                <p><strong>Birthday:</strong> <?= htmlspecialchars($student['birthdate']) ?></p>
                <p><strong>Gender:</strong> <?= htmlspecialchars($student['gender']) ?></p> 
                <p><strong>Contact Number:</strong> <?= htmlspecialchars($student['contact_no']) ?></p> 
                <p><strong>Email:</strong> <?= htmlspecialchars($student['email']) ?></p> 
            </div>
            <h2>Enrollment History</h2>
            <?php if (!empty($enrollments)): ?>
                <table class="student-table detail-table">
                    <tr>
                        <th>School Year</th>
                        <th>Semester</th>
                        <th>Course</th>
                        <th>Date Enrolled</th>
                    </tr>
                    <?php foreach ($enrollments as $enrollment): ?>
                        <?php
                            $courseLabel = ($enrollment['course_code'] ?? 'N/A') . ' - ' . ($enrollment['course_name'] ?? 'N/A');
                        ?>
                        <tr>
                            <td>
                                <a href="student.php?id=<?= urlencode($studentId) ?>&enrollment=<?= urlencode($enrollment['enrollment_id']) ?>">
                                    <?= htmlspecialchars($enrollment['school_year']) ?>
                                </a>
                            </td>
                            <td>
                                <a href="student.php?id=<?= urlencode($studentId) ?>&enrollment=<?= urlencode($enrollment['enrollment_id']) ?>">
                                    <?= htmlspecialchars($enrollment['semester']) ?>
                                </a>
                            </td>
                            <td><?= htmlspecialchars($courseLabel) ?></td>
                            <td><?= htmlspecialchars($enrollment['date_enrolled']) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </table>
            <?php else: ?>
                <p>No enrollment history yet.</p>
            <?php endif; ?>

            <?php if ($selectedEnrollmentId > 0): ?>
                <?php
                    $selectedEnrollment = null;
                    foreach ($enrollments as $enr) {
                        if ((int)$enr['enrollment_id'] === $selectedEnrollmentId) {
                            $selectedEnrollment = $enr;
                            break;
                        }
                    }
                ?>
                <h2>Class Schedule & Grades</h2>
                <?php if ($selectedEnrollment): ?>
                    <p>
                        <?= htmlspecialchars($selectedEnrollment['school_year']) ?> -
                        <?= htmlspecialchars($selectedEnrollment['semester']) ?>
                    </p>
                    <?php if (!empty($classRows)): ?>
                        <table class="student-table detail-table">
                            <tr>
                                <th>Subject</th>
                                <th>Schedule</th>
                                <th>Teacher</th>
                                <th>Final Grade</th>
                                <th>Remarks</th>
                            </tr>
                            <?php foreach ($classRows as $class): ?>
                                <?php
                                    $subjectLabel = trim(($class['subject_code'] ?? '') . ' - ' . ($class['subject_name'] ?? ''));
                                    $scheduleLabel = trim(($class['schedule_day'] ?? '') . ' ' . ($class['schedule_time'] ?? '') . ' @ ' . ($class['room'] ?? ''));
                                    $hasTeacher = !empty($class['teacher_lastname']) || !empty($class['teacher_firstname']);
                                    $teacherLabel = $hasTeacher
                                        ? trim(($class['teacher_lastname'] ?? '') . ', ' . ($class['teacher_firstname'] ?? ''))
                                        : 'N/A';
                                ?>
                                <tr>
                                    <td><?= htmlspecialchars($subjectLabel ?: 'N/A') ?></td>
                                    <td><?= htmlspecialchars($scheduleLabel ?: 'N/A') ?></td>
                                    <td><?= htmlspecialchars($teacherLabel) ?></td>
                                    <td><?= htmlspecialchars($class['final_grade'] ?? '') ?></td>
                                    <td><?= htmlspecialchars($class['remarks'] ?? '') ?></td>
                                </tr>
                            <?php endforeach; ?>
                        </table>
                    <?php else: ?>
                        <p>No class schedules found for this term.</p>
                    <?php endif; ?>
                <?php else: ?>
                    <p>Enrollment not found for this student.</p>
                <?php endif; ?>
            <?php endif; ?>
        <?php else: ?>
            <p>Student not found.</p>
        <?php endif; ?>
    </div>
</body>
</html>
