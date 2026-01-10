<?php
require_once '../config/db_helpers.php';

$student_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if ($student_id <= 0) {
    header('Location: ../index.php');
    exit;
}

$conn = getDBConnection();
$message = '';
$message_type = '';

// Get student info with program
$sql = "SELECT s.*, p.program_name, p.program_code, p.program_id
        FROM students s 
        LEFT JOIN programs p ON s.program_id = p.program_id 
        WHERE s.student_id = ?";
$result = db_query($conn, $sql, 'i', [$student_id]);
if (!$result || $result->num_rows === 0) {
    $conn->close();
    header('Location: ../index.php?msg=notfound');
    exit;
}
$student = db_fetch_one($result);

// Get filter parameters
$selected_year = isset($_GET['year']) ? intval($_GET['year']) : intval($student['year_level']);
$selected_semester = isset($_GET['semester']) ? intval($_GET['semester']) : 1;
if ($selected_year < 1) $selected_year = 1;
if ($selected_year > 4) $selected_year = 4;
if ($selected_semester !== 1 && $selected_semester !== 2) $selected_semester = 1;

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    $enrollment_id = intval($_POST['enrollment_id'] ?? 0);
    $curriculum_id = intval($_POST['curriculum_id'] ?? 0);
    
    if ($action === 'drop' && $enrollment_id > 0) {
        // Drop the course (update status to Dropped)
        $update_sql = "UPDATE enrollments SET status = 'Dropped' WHERE enrollment_id = ? AND student_id = ?";
        $update_result = db_query($conn, $update_sql, 'ii', [$enrollment_id, $student_id]);
        if ($update_result) {
            $message = 'Course dropped successfully.';
            $message_type = 'success';
        } else {
            $message = 'Failed to drop course.';
            $message_type = 'error';
        }
    } elseif ($action === 'enroll' && $curriculum_id > 0) {
        // Check if already enrolled
        $check_sql = "SELECT enrollment_id, status FROM enrollments WHERE student_id = ? AND curriculum_id = ?";
        $check_result = db_query($conn, $check_sql, 'ii', [$student_id, $curriculum_id]);
        $existing = $check_result ? db_fetch_one($check_result) : null;
        
        if ($existing) {
            if ($existing['status'] === 'Dropped') {
                // Re-enroll
                $update_sql = "UPDATE enrollments SET status = 'Enrolled' WHERE enrollment_id = ?";
                db_query($conn, $update_sql, 'i', [$existing['enrollment_id']]);
                $message = 'Course re-enrolled successfully.';
                $message_type = 'success';
            } else {
                $message = 'Already enrolled in this course.';
                $message_type = 'error';
            }
        } else {
            // New enrollment
            $academic_year = date('Y') . '-' . (date('Y') + 1);
            $insert_sql = "INSERT INTO enrollments (student_id, curriculum_id, academic_year, status) VALUES (?, ?, ?, 'Enrolled')";
            $insert_result = db_query($conn, $insert_sql, 'iis', [$student_id, $curriculum_id, $academic_year]);
            if ($insert_result) {
                $message = 'Course enrolled successfully.';
                $message_type = 'success';
            } else {
                $message = 'Failed to enroll in course.';
                $message_type = 'error';
            }
        }
    } elseif ($action === 'reenroll' && $enrollment_id > 0) {
        // Re-enroll a dropped course
        $update_sql = "UPDATE enrollments SET status = 'Enrolled' WHERE enrollment_id = ? AND student_id = ?";
        $update_result = db_query($conn, $update_sql, 'ii', [$enrollment_id, $student_id]);
        if ($update_result) {
            $message = 'Course re-enrolled successfully.';
            $message_type = 'success';
        } else {
            $message = 'Failed to re-enroll in course.';
            $message_type = 'error';
        }
    }
}

// Get current enrollments for the student (for this year/semester)
$enrollments_sql = "SELECT e.*, c.course_code, c.course_name, c.units, c.year_level, c.semester
                    FROM enrollments e
                    JOIN curriculum c ON e.curriculum_id = c.curriculum_id
                    WHERE e.student_id = ? AND c.year_level = ? AND c.semester = ?
                    ORDER BY c.course_code";
$enrollments_result = db_query($conn, $enrollments_sql, 'iii', [$student_id, $selected_year, $selected_semester]);
$enrollments = $enrollments_result ? db_fetch_all($enrollments_result) : [];

// Get all available courses for the student's program (for this year/semester)
// Only show courses they're NOT currently enrolled in (or dropped)
$available_sql = "SELECT c.* 
                  FROM curriculum c
                  WHERE c.program_id = ? 
                  AND c.year_level = ? 
                  AND c.semester = ?
                  AND c.curriculum_id NOT IN (
                      SELECT curriculum_id FROM enrollments 
                      WHERE student_id = ? AND status != 'Dropped'
                  )
                  ORDER BY c.course_code";
$available_result = db_query($conn, $available_sql, 'iiii', [$student['program_id'], $selected_year, $selected_semester, $student_id]);
$available_courses = $available_result ? db_fetch_all($available_result) : [];

// Calculate totals
$enrolled_units = 0;
$enrolled_count = 0;
foreach ($enrollments as $e) {
    if ($e['status'] !== 'Dropped') {
        $enrolled_units += $e['units'];
        $enrolled_count++;
    }
}

$conn->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Enrollment - <?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/details.css">
    <style>
        .enrollment-summary {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .summary-item {
            padding: 10px 20px;
            background: #fff;
            border-radius: 6px;
            border: 1px solid #e9ecef;
        }
        .summary-item .label {
            font-size: 12px;
            color: #6c757d;
            text-transform: uppercase;
        }
        .summary-item .value {
            font-size: 24px;
            font-weight: 700;
            color: #333;
        }
        .section-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 25px 0 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        .section-title h3 {
            margin: 0;
        }
        .enrollment-table {
            width: 100%;
            border-collapse: collapse;
        }
        .enrollment-table th,
        .enrollment-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        .enrollment-table th {
            background: #f8f9fa;
            font-weight: 600;
            font-size: 13px;
            color: #495057;
        }
        .enrollment-table tr:hover {
            background: #f8f9fa;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }
        .btn-enroll {
            background: transparent;
            color: #40c057;
            border: 1px solid #40c057;
        }
        .btn-enroll:hover {
            background: #40c057;
            color: #fff;
        }
        .btn-unenroll {
            background: transparent;
            color: #fa5252;
            border: 1px solid #fa5252;
        }
        .btn-unenroll:hover {
            background: #fa5252;
            color: #fff;
        }
        .btn-reenroll {
            background: transparent;
            color: #4361ee;
            border: 1px solid #4361ee;
        }
        .btn-reenroll:hover {
            background: #4361ee;
            color: #fff;
        }
        .status-enrolled {
            background: #d1e7dd;
            color: #0f5132;
        }
        .status-dropped {
            background: #f8d7da;
            color: #842029;
        }
        .status-completed {
            background: #cff4fc;
            color: #055160;
        }
        .no-courses {
            padding: 30px;
            text-align: center;
            color: #6c757d;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .message {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .message.success {
            background: #d1e7dd;
            color: #0f5132;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Edit Enrollment</h1>
            <div class="header-actions">
                <a href="student_schedules.php?id=<?php echo $student_id; ?>" class="btn btn-back">← Back to Schedules</a>
                <a href="student_personal.php?id=<?php echo $student_id; ?>" class="btn btn-info">Personal Info</a>
                <a href="student_grades.php?id=<?php echo $student_id; ?>" class="btn btn-grades">View Grades</a>
            </div>
        </header>

        <?php if ($message): ?>
            <div class="message <?php echo $message_type; ?>">
                <?php echo $message; ?>
            </div>
        <?php endif; ?>

        <div class="student-details">
            <div class="student-name-header">
                <h2><?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></h2>
                <span class="program-badge"><?php echo htmlspecialchars($student['program_code']); ?> - Year <?php echo $student['year_level']; ?></span>
            </div>

            <!-- Filter Form -->
            <div class="filter-section">
                <form method="get" class="schedule-filter">
                    <input type="hidden" name="id" value="<?php echo $student_id; ?>">
                    <label for="yearSelect">Year Level:</label>
                    <select id="yearSelect" name="year" class="sort-select" onchange="this.form.submit()">
                        <?php for ($y = 1; $y <= 4; $y++): ?>
                            <option value="<?php echo $y; ?>" <?php echo $selected_year == $y ? 'selected' : ''; ?>>Year <?php echo $y; ?></option>
                        <?php endfor; ?>
                    </select>
                    <label for="semesterSelect">Semester:</label>
                    <select id="semesterSelect" name="semester" class="sort-select" onchange="this.form.submit()">
                        <option value="1" <?php echo $selected_semester == 1 ? 'selected' : ''; ?>>1st Semester</option>
                        <option value="2" <?php echo $selected_semester == 2 ? 'selected' : ''; ?>>2nd Semester</option>
                    </select>
                </form>
            </div>

            <!-- Enrollment Summary -->
            <div class="enrollment-summary">
                <div class="summary-item">
                    <div class="label">Enrolled Courses</div>
                    <div class="value"><?php echo $enrolled_count; ?></div>
                </div>
                <div class="summary-item">
                    <div class="label">Total Units</div>
                    <div class="value"><?php echo $enrolled_units; ?></div>
                </div>
                <div class="summary-item">
                    <div class="label">Available to Add</div>
                    <div class="value"><?php echo count($available_courses); ?></div>
                </div>
            </div>

            <!-- Current Enrollments -->
            <div class="section-title">
                <h3>Current Enrollments - Year <?php echo $selected_year; ?>, Semester <?php echo $selected_semester; ?></h3>
            </div>

            <?php if (!empty($enrollments)): ?>
                <div class="table-container">
                    <table class="enrollment-table">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Units</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($enrollments as $enrollment): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($enrollment['course_code']); ?></td>
                                    <td><?php echo htmlspecialchars($enrollment['course_name']); ?></td>
                                    <td><?php echo htmlspecialchars($enrollment['units']); ?></td>
                                    <td>
                                        <span class="status-badge status-<?php echo strtolower($enrollment['status']); ?>">
                                            <?php echo htmlspecialchars($enrollment['status']); ?>
                                        </span>
                                    </td>
                                    <td>
                                        <?php if ($enrollment['status'] === 'Enrolled'): ?>
                                            <form method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to drop this course?');">
                                                <input type="hidden" name="action" value="drop">
                                                <input type="hidden" name="enrollment_id" value="<?php echo $enrollment['enrollment_id']; ?>">
                                                <button type="submit" class="btn btn-sm btn-unenroll">Drop</button>
                                            </form>
                                        <?php elseif ($enrollment['status'] === 'Dropped'): ?>
                                            <form method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="reenroll">
                                                <input type="hidden" name="enrollment_id" value="<?php echo $enrollment['enrollment_id']; ?>">
                                                <button type="submit" class="btn btn-sm btn-reenroll">Re-enroll</button>
                                            </form>
                                        <?php else: ?>
                                            <span class="text-muted">-</span>
                                        <?php endif; ?>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php else: ?>
                <div class="no-courses">No enrollments found for this semester.</div>
            <?php endif; ?>

            <!-- Available Courses to Enroll -->
            <div class="section-title">
                <h3>Available Courses (<?php echo htmlspecialchars($student['program_code']); ?> Program)</h3>
            </div>

            <?php if (!empty($available_courses)): ?>
                <div class="table-container">
                    <table class="enrollment-table">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Units</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($available_courses as $course): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($course['course_code']); ?></td>
                                    <td><?php echo htmlspecialchars($course['course_name']); ?></td>
                                    <td><?php echo htmlspecialchars($course['units']); ?></td>
                                    <td>
                                        <form method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="enroll">
                                            <input type="hidden" name="curriculum_id" value="<?php echo $course['curriculum_id']; ?>">
                                            <button type="submit" class="btn btn-sm btn-enroll">Enroll</button>
                                        </form>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php else: ?>
                <div class="no-courses">All available courses for this semester are already enrolled.</div>
            <?php endif; ?>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div class="spinner-overlay" id="loadingSpinner">
        <div class="spinner"></div>
    </div>

    <script>
        function showSpinner() {
            document.getElementById('loadingSpinner').classList.add('active');
        }

        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function() {
                showSpinner();
            });
        });
    </script>
</body>
</html>
