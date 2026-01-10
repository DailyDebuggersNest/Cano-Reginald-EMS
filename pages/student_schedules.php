<?php
require_once '../config/db_helpers.php';

$student_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if ($student_id <= 0) {
    header('Location: ../index.php');
    exit;
}

$conn = getDBConnection();

// Query to get student information with program
$sql = "SELECT s.*, p.program_name, p.program_code
        FROM students s 
        LEFT JOIN programs p ON s.program_id = p.program_id 
        WHERE s.student_id = ?";
$result = db_query($conn, $sql, 'i', [$student_id]);
if (!$result || $result->num_rows === 0) {
    $conn->close();
    header('Location: ../index.php');
    exit;
}
$student = db_fetch_one($result);

// Get filter parameters - default to student's current year level and 1st semester
$selected_year = isset($_GET['year']) ? intval($_GET['year']) : intval($student['year_level']);
$selected_semester = isset($_GET['semester']) ? intval($_GET['semester']) : 1;
if ($selected_year < 0) $selected_year = 0;
if ($selected_year > 4) $selected_year = 4;
if ($selected_semester !== 1 && $selected_semester !== 2) $selected_semester = 0;

// Get schedules for courses the student is enrolled in (matching grades view)
$schedules_sql = "SELECT sc.*, c.course_code, c.course_name, c.units, c.year_level, c.semester, c.description as course_description, e.status as enrollment_status
                  FROM enrollments e
                  JOIN curriculum c ON e.curriculum_id = c.curriculum_id
                  JOIN schedules sc ON sc.curriculum_id = c.curriculum_id
                  WHERE e.student_id = ?";
$params = [$student_id];
$types = 'i';
if ($selected_year > 0) {
    $schedules_sql .= " AND c.year_level = ?";
    $params[] = $selected_year;
    $types .= 'i';
}
if ($selected_semester > 0) {
    $schedules_sql .= " AND c.semester = ?";
    $params[] = $selected_semester;
    $types .= 'i';
}
$schedules_sql .= " ORDER BY c.year_level, c.semester, sc.day_of_week, sc.start_time";
$schedules_result = db_query($conn, $schedules_sql, $types, $params);
$schedules = $schedules_result ? db_fetch_all($schedules_result) : [];

// Get enrolled courses for the selected year/semester (fallback if no schedules)
$curriculum_sql = "SELECT c.*, e.status as enrollment_status 
                   FROM enrollments e
                   JOIN curriculum c ON e.curriculum_id = c.curriculum_id
                   WHERE e.student_id = ?";
$curr_params = [$student_id];
$curr_types = 'i';
if ($selected_year > 0) {
    $curriculum_sql .= " AND c.year_level = ?";
    $curr_params[] = $selected_year;
    $curr_types .= 'i';
}
if ($selected_semester > 0) {
    $curriculum_sql .= " AND c.semester = ?";
    $curr_params[] = $selected_semester;
    $curr_types .= 'i';
}
$curriculum_sql .= " ORDER BY c.year_level, c.semester, c.course_code";
$curriculum_result = db_query($conn, $curriculum_sql, $curr_types, $curr_params);
$courses = $curriculum_result ? db_fetch_all($curriculum_result) : [];

// Calculate total units for display and group schedules by course
$total_units = 0;
$unique_courses = [];
$grouped_schedules = [];
foreach ($schedules as $sched) {
    $cid = $sched['curriculum_id'];
    if (!isset($unique_courses[$cid])) {
        $unique_courses[$cid] = $sched['units'];
        $total_units += $sched['units'];
        $grouped_schedules[$cid] = [
            'course_code' => $sched['course_code'],
            'course_name' => $sched['course_name'],
            'units' => $sched['units'],
            'year_level' => $sched['year_level'],
            'semester' => $sched['semester'],
            'meetings' => []
        ];
    }
    $grouped_schedules[$cid]['meetings'][] = [
        'day' => $sched['day_of_week'],
        'start_time' => $sched['start_time'],
        'end_time' => $sched['end_time'],
        'room' => $sched['room'],
        'instructor' => $sched['instructor'] ?? 'TBA'
    ];
}
// Fallback to courses if schedules empty
if (empty($schedules) && !empty($courses)) {
    foreach ($courses as $course) {
        $total_units += $course['units'];
    }
}

$conn->close();

// Helper function to format day
function formatDay($day) {
    $days = ['Mon' => 'Monday', 'Tue' => 'Tuesday', 'Wed' => 'Wednesday', 'Thu' => 'Thursday', 'Fri' => 'Friday', 'Sat' => 'Saturday', 'Sun' => 'Sunday'];
    return $days[$day] ?? $day;
}

// Helper function to format time
function formatTime($time) {
    return date('g:i A', strtotime($time));
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Schedules - <?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/details.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Class Schedules</h1>
            <div class="header-actions">
                <a href="../index.php" class="btn btn-back">← Back to Student List</a>
                <a href="student_personal.php?id=<?php echo $student_id; ?>" class="btn btn-info">Personal Info</a>
                <a href="student_grades.php?id=<?php echo $student_id; ?>" class="btn btn-grades">View Grades</a>
                <a href="edit_enrollment.php?id=<?php echo $student_id; ?>&year=<?php echo $selected_year > 0 ? $selected_year : $student['year_level']; ?>&semester=<?php echo $selected_semester > 0 ? $selected_semester : 1; ?>" class="btn btn-edit">Edit Enrollment</a>
            </div>
        </header>

        <div class="student-details">
            <div class="student-name-header">
                <h2><?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></h2>
                <span class="program-badge"><?php echo htmlspecialchars($student['program_code'] ?? 'N/A'); ?> - Year <?php echo $student['year_level']; ?></span>
            </div>

            <!-- Filter Form -->
            <div class="filter-section">
                <form method="get" class="schedule-filter">
                    <input type="hidden" name="id" value="<?php echo $student_id; ?>">
                    <label for="yearSelect">Year Level:</label>
                    <select id="yearSelect" name="year" class="sort-select" onchange="this.form.submit()">
                        <option value="0" <?php echo $selected_year == 0 ? 'selected' : ''; ?>>All Years</option>
                        <?php for ($y = 1; $y <= 4; $y++): ?>
                            <option value="<?php echo $y; ?>" <?php echo $selected_year == $y ? 'selected' : ''; ?>>Year <?php echo $y; ?></option>
                        <?php endfor; ?>
                    </select>
                    <label for="semesterSelect">Semester:</label>
                    <select id="semesterSelect" name="semester" class="sort-select" onchange="this.form.submit()">
                        <option value="0" <?php echo $selected_semester == 0 ? 'selected' : ''; ?>>All Semesters</option>
                        <option value="1" <?php echo $selected_semester == 1 ? 'selected' : ''; ?>>1st Semester</option>
                        <option value="2" <?php echo $selected_semester == 2 ? 'selected' : ''; ?>>2nd Semester</option>
                    </select>
                    <span class="total-units-badge">Total Units: <?php echo $total_units; ?></span>
                </form>
            </div>

            <?php if (!empty($grouped_schedules)): ?>
                <!-- Schedules Table -->
                <h3>Class Schedule - Year <?php echo $selected_year; ?><?php echo $selected_semester > 0 ? ' (Semester ' . $selected_semester . ')' : ''; ?></h3>
                <div class="table-container">
                    <table class="schedule-table">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Schedule</th>
                                <th>Room</th>
                                <th>Instructor</th>
                                <th>Units</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($grouped_schedules as $course): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($course['course_code']); ?></td>
                                    <td><?php echo htmlspecialchars($course['course_name']); ?></td>
                                    <td>
                                        <?php foreach ($course['meetings'] as $i => $meeting): ?>
                                            <?php echo formatDay($meeting['day']); ?> <?php echo formatTime($meeting['start_time']) . ' - ' . formatTime($meeting['end_time']); ?><?php echo $i < count($course['meetings']) - 1 ? '<br>' : ''; ?>
                                        <?php endforeach; ?>
                                    </td>
                                    <td><?php echo htmlspecialchars($course['meetings'][0]['room'] ?? 'TBA'); ?></td>
                                    <td><?php echo htmlspecialchars($course['meetings'][0]['instructor'] ?? 'TBA'); ?></td>
                                    <td><?php echo htmlspecialchars($course['units']); ?></td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="5" style="text-align: right; font-weight: 600;">Total Units:</td>
                                <td style="font-weight: 600;"><?php echo $total_units; ?></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            <?php elseif (!empty($courses)): ?>
                <!-- Curriculum Courses Table (when no specific schedules) -->
                <h3>Courses - Year <?php echo $selected_year; ?><?php echo $selected_semester > 0 ? ' (Semester ' . $selected_semester . ')' : ''; ?></h3>
                <div class="table-container">
                    <table class="schedule-table">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Semester</th>
                                <th>Units</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($courses as $course): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($course['course_code']); ?></td>
                                    <td><?php echo htmlspecialchars($course['course_name']); ?></td>
                                    <td><?php echo htmlspecialchars($course['semester']); ?></td>
                                    <td><?php echo htmlspecialchars($course['units']); ?></td>
                                    <td><?php echo htmlspecialchars($course['description'] ?? ''); ?></td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php else: ?>
                <p class="no-data">No courses or schedules found for Year <?php echo $selected_year; ?><?php echo $selected_semester > 0 ? ' - Semester ' . $selected_semester : ''; ?>.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
