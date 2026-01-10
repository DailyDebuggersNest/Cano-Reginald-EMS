<?php
require_once 'config/database.php';

// Get student ID from URL
$student_id = isset($_GET['id']) ? intval($_GET['id']) : 0;

if ($student_id <= 0) {
    header('Location: index.php');
    exit;
}

// Get database connection
$conn = getDBConnection();

// Query to get student information with curriculum
$sql = "SELECT s.*, c.curriculum_name, c.curriculum_code, c.description as curriculum_description
        FROM student s 
        LEFT JOIN curriculum c ON s.curriculum_id = c.curriculum_id 
        WHERE s.student_id = ?";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $student_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    $conn->close();
    header('Location: index.php');
    exit;
}

$student = $result->fetch_assoc();

// Determine available enrollment years from enrollment table
$enroll_sql = $conn->prepare("SELECT MIN(year_level) AS first_year, MAX(year_level) AS last_year FROM enrollment WHERE student_id = ?");
$enroll_sql->bind_param('i', $student_id);
$enroll_sql->execute();
$enroll_res = $enroll_sql->get_result();
$enroll_info = $enroll_res->fetch_assoc();
$first_year = $enroll_info['first_year'] ? intval($enroll_info['first_year']) : intval($student['year_level']);
$last_year = $enroll_info['last_year'] ? intval($enroll_info['last_year']) : intval($student['year_level']);
// Get filters from URL: start year, selected year and semester
$start_year = isset($_GET['start_year']) ? intval($_GET['start_year']) : $first_year;
if ($start_year < $first_year) $start_year = $first_year;
if ($start_year > $last_year) $start_year = $first_year;

$selected_year = isset($_GET['selected_year']) ? intval($_GET['selected_year']) : intval($student['year_level']);
if ($selected_year < $start_year) $selected_year = $start_year;
if ($selected_year > $last_year) $selected_year = $last_year;

$selected_semester = isset($_GET['selected_semester']) ? intval($_GET['selected_semester']) : 0;
if ($selected_semester !== 1 && $selected_semester !== 2) $selected_semester = 0;

// Get courses for the selected year/semester (from curriculum)
$courses_sql = "SELECT course_id, course_code, course_name, units, semester, description 
                FROM courses 
                WHERE curriculum_id = ? AND year_level = ?";
if ($selected_semester > 0) {
    $courses_sql .= " AND semester = ?";
}
$courses_sql .= " ORDER BY semester, course_code";

$courses_stmt = $conn->prepare($courses_sql);
if ($selected_semester > 0) {
    $courses_stmt->bind_param("iii", $student['curriculum_id'], $selected_year, $selected_semester);
} else {
    $courses_stmt->bind_param("ii", $student['curriculum_id'], $selected_year);
}
$courses_stmt->execute();
$courses_result = $courses_stmt->get_result();

// Get courses the student has taken for the selected year/semester (subjects_enrolled)
$taken_courses = [];
$taken_sql = "SELECT se.*, c.course_code, c.course_name, c.units, c.description FROM subjects_enrolled se JOIN courses c ON se.course_id = c.course_id WHERE se.student_id = ? AND se.year_level = ?";
if ($selected_semester > 0) {
    $taken_sql .= " AND se.semester = ?";
}
$taken_stmt = $conn->prepare($taken_sql);
if ($selected_semester > 0) {
    $taken_stmt->bind_param('iii', $student_id, $selected_year, $selected_semester);
} else {
    $taken_stmt->bind_param('ii', $student_id, $selected_year);
}
$taken_stmt->execute();
$taken_res = $taken_stmt->get_result();
while ($tc = $taken_res->fetch_assoc()) {
    $taken_courses[] = $tc;
}

// Determine completion status for the selected year/semester
$completion_status = 'In Progress';
// First check enrollment table for explicit status
$enr_check = $conn->prepare("SELECT status FROM enrollment WHERE student_id = ? AND year_level = ? AND semester = ? LIMIT 1");
$sem_to_check = ($selected_semester > 0) ? $selected_semester : 1;
$enr_check->bind_param('iii', $student_id, $selected_year, $sem_to_check);
$enr_check->execute();
$enr_res2 = $enr_check->get_result();
if ($enr_res2 && $enr_res2->num_rows > 0) {
    $row_enr = $enr_res2->fetch_assoc();
    if ($row_enr['status'] === 'Completed') {
        $completion_status = 'Completed';
    }
}

// Fallback/complementary check: compare number of curriculum courses vs student's recorded subjects
if ($completion_status !== 'Completed') {
    // count required courses for this curriculum/year/semester
    $req_count = 0;
    $req_stmt = $conn->prepare("SELECT COUNT(*) AS cnt FROM courses WHERE curriculum_id = ? AND year_level = ?" . ($selected_semester > 0 ? " AND semester = ?" : ""));
    if ($selected_semester > 0) {
        $req_stmt->bind_param('iii', $student['curriculum_id'], $selected_year, $selected_semester);
    } else {
        $req_stmt->bind_param('ii', $student['curriculum_id'], $selected_year);
    }
    $req_stmt->execute();
    $req_res = $req_stmt->get_result();
    if ($req_res && $r = $req_res->fetch_assoc()) {
        $req_count = intval($r['cnt']);
    }

    if ($req_count > 0) {
        // count how many subjects_enrolled the student has for that year/semester
        $taken_count = 0;
        $taken_stmt = $conn->prepare("SELECT COUNT(*) AS cnt FROM subjects_enrolled WHERE student_id = ? AND year_level = ?" . ($selected_semester > 0 ? " AND semester = ?" : ""));
        if ($selected_semester > 0) {
            $taken_stmt->bind_param('iii', $student_id, $selected_year, $selected_semester);
        } else {
            $taken_stmt->bind_param('ii', $student_id, $selected_year);
        }
        $taken_stmt->execute();
        $taken_res2 = $taken_stmt->get_result();
        if ($taken_res2 && $tr = $taken_res2->fetch_assoc()) {
            $taken_count = intval($tr['cnt']);
        }

        if ($taken_count >= $req_count) {
            $completion_status = 'Completed';
        }
    }
}

// Build year/semester status summary from start_year..last_year
$year_statuses = [];
for ($y = $start_year; $y <= $last_year; $y++) {
    $s1 = 'Not Enrolled';
    $s2 = 'Not Enrolled';

    $e1 = $conn->prepare("SELECT status FROM enrollment WHERE student_id = ? AND year_level = ? AND semester = 1 LIMIT 1");
    $e1->bind_param('ii', $student_id, $y);
    $e1->execute();
    $r1 = $e1->get_result();
    if ($r1 && $r1->num_rows > 0) {
        $row1 = $r1->fetch_assoc();
        $s1 = $row1['status'];
    }

    $e2 = $conn->prepare("SELECT status FROM enrollment WHERE student_id = ? AND year_level = ? AND semester = 2 LIMIT 1");
    $e2->bind_param('ii', $student_id, $y);
    $e2->execute();
    $r2 = $e2->get_result();
    if ($r2 && $r2->num_rows > 0) {
        $row2 = $r2->fetch_assoc();
        $s2 = $row2['status'];
    }

    // Determine year-level status
    if ($s1 === 'Completed' && $s2 === 'Completed') {
        $ystatus = 'Completed';
    } elseif ($s1 === 'Not Enrolled' && $s2 === 'Not Enrolled') {
        $ystatus = 'Not Enrolled';
    } elseif ($s1 === 'Completed' || $s2 === 'Completed') {
        $ystatus = 'Partially Completed';
    } elseif ($s1 === 'Enrolled' || $s2 === 'Enrolled') {
        $ystatus = 'In Progress';
    } else {
        $ystatus = 'Partially Completed';
    }

    $year_statuses[$y] = [
        'sem1' => $s1,
        'sem2' => $s2,
        'year' => $ystatus
    ];
    $e1->close();
    $e2->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Details - <?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/details.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Student Details</h1>
            <a href="index.php" class="btn btn-back">← Back to Student List</a>
        </header>

        <div class="student-details">
            <h2>Personal Information</h2>
            <div class="info-section">
                <div class="info-item">
                    <span class="info-label">Student Number:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['student_number']); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">First Name:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['first_name']); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Middle Name:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['middle_name'] ?? 'N/A'); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Last Name:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['last_name']); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Email:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['email'] ?? 'N/A'); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Phone:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['phone'] ?? 'N/A'); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Address:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['address'] ?? 'N/A'); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Date of Birth:</span>
                    <span class="info-value"><?php echo $student['date_of_birth'] ? date('F d, Y', strtotime($student['date_of_birth'])) : 'N/A'; ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Gender:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['gender'] ?? 'N/A'); ?></span>
                </div>
            </div>

            <h2>Academic Information</h2>
            <div class="info-section">
                <div class="info-item">
                    <span class="info-label">Curriculum:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['curriculum_code'] ?? 'N/A'); ?> - <?php echo htmlspecialchars($student['curriculum_name'] ?? 'N/A'); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Curriculum Description:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['curriculum_description'] ?? 'N/A'); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Year Level:</span>
                    <span class="info-value"><?php echo htmlspecialchars($student['year_level']); ?></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Status:</span>
                    <span class="info-value"><span class='status-badge status-<?php echo strtolower($student['status']); ?>'><?php echo htmlspecialchars($student['status']); ?></span></span>
                </div>
                <div class="info-item">
                    <span class="info-label">Date Enrolled:</span>
                    <span class="info-value"><?php echo $student['created_at'] ? date('F d, Y', strtotime($student['created_at'])) : 'N/A'; ?></span>
                </div>
            </div>

            <div class="courses-header">
                <h2>Year <?php echo htmlspecialchars($selected_year); ?> Courses</h2>
                <div class="semester-filter">
                            <form id="coursesFilter" method="get">
                                <input type="hidden" name="id" value="<?php echo $student_id; ?>">
                                <label for="startYearSelect">Start Year:</label>
                                <select id="startYearSelect" name="start_year">
                                    <?php for ($y = $first_year; $y <= $last_year; $y++): ?>
                                        <option value="<?php echo $y; ?>" <?php echo $start_year == $y ? 'selected' : ''; ?>><?php echo $y; ?></option>
                                    <?php endfor; ?>
                                </select>

                                <label for="yearSelect">Year:</label>
                                <select id="yearSelect" name="selected_year">
                                    <?php for ($y = $start_year; $y <= $last_year; $y++): ?>
                                        <option value="<?php echo $y; ?>" <?php echo $selected_year == $y ? 'selected' : ''; ?>><?php echo $y; ?></option>
                                    <?php endfor; ?>
                                </select>

                                <label for="semesterSelect">Semester:</label>
                                <select id="semesterSelect" name="selected_semester">
                                    <option value="0" <?php echo $selected_semester == 0 ? 'selected' : ''; ?>>All</option>
                                    <option value="1" <?php echo $selected_semester == 1 ? 'selected' : ''; ?>>1</option>
                                    <option value="2" <?php echo $selected_semester == 2 ? 'selected' : ''; ?>>2</option>
                                </select>

                                <button class="btn">Filter</button>
                            </form>
                </div>
            </div>

                <div class="year-summary">
                    <h3>Year Summary (<?php echo htmlspecialchars($start_year); ?> → <?php echo htmlspecialchars($last_year); ?>)</h3>
                    <table class="summary-table">
                        <thead>
                            <tr>
                                <th>Year</th>
                                <th>Semester 1</th>
                                <th>Semester 2</th>
                                <th>Year Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php for ($y = $start_year; $y <= $last_year; $y++): ?>
                                <tr>
                                    <td><?php echo $y; ?></td>
                                    <td><?php echo htmlspecialchars($year_statuses[$y]['sem1']); ?></td>
                                    <td><?php echo htmlspecialchars($year_statuses[$y]['sem2']); ?></td>
                                    <td><?php echo htmlspecialchars($year_statuses[$y]['year']); ?></td>
                                    <td><a class="btn" href="?id=<?php echo $student_id; ?>&start_year=<?php echo $start_year; ?>&selected_year=<?php echo $y; ?>">View</a></td>
                                </tr>
                            <?php endfor; ?>
                        </tbody>
                    </table>
                </div>

            <?php if ($courses_result && $courses_result->num_rows > 0): ?>
                <?php
                $current_semester = 0;
                $courses_result->data_seek(0); // Reset result pointer
                ?>
                <?php while ($course = $courses_result->fetch_assoc()): ?>
                    <?php if ($course['semester'] != $current_semester): ?>
                        <?php if ($current_semester > 0): ?>
                            </div>
                        <?php endif; ?>
                        <?php $current_semester = $course['semester']; ?>
                        <?php if ($selected_semester == 0): ?>
                            <h3>Semester <?php echo htmlspecialchars($current_semester); ?></h3>
                        <?php endif; ?>
                        <div class="courses-section">
                    <?php endif; ?>
                    <div class="course-item">
                        <div class="course-header">
                            <span class="course-code"><?php echo htmlspecialchars($course['course_code']); ?></span>
                            <span class="course-units"><?php echo htmlspecialchars($course['units']); ?> units</span>
                        </div>
                        <div class="course-name"><?php echo htmlspecialchars($course['course_name']); ?></div>
                        <div class="course-description"><?php echo htmlspecialchars($course['description'] ?? 'N/A'); ?></div>
                    </div>
                <?php endwhile; ?>
                </div>
            <?php else: ?>
                <p class="no-data">No courses found for year level <?php echo htmlspecialchars($selected_year); ?><?php echo $selected_semester > 0 ? ' - Semester ' . $selected_semester : ''; ?>.</p>
            <?php endif; ?>

            <div class="taken-courses">
                <h3>Courses Taken (Year <?php echo htmlspecialchars($selected_year); ?><?php echo $selected_semester > 0 ? ' - Semester ' . $selected_semester : ''; ?>)</h3>
                <p><strong>Status:</strong> <?php echo htmlspecialchars($completion_status); ?></p>
                <?php if (!empty($taken_courses)): ?>
                    <ul>
                        <?php foreach ($taken_courses as $tc): ?>
                            <li><?php echo htmlspecialchars($tc['course_code'] . ' - ' . $tc['course_name'] . ' (' . ($tc['grade'] ?? 'N/A') . ')'); ?></li>
                        <?php endforeach; ?>
                    </ul>
                <?php else: ?>
                    <p class="no-data">No recorded courses taken for this selection.</p>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <?php
    $conn->close();
    ?>
    <script>
        // Auto-submit filter form when selects change
        const coursesFilter = document.getElementById('coursesFilter');
        if (coursesFilter) {
            const yearSelect = document.getElementById('yearSelect');
            const semesterSelect = document.getElementById('semesterSelect');
            if (yearSelect) yearSelect.addEventListener('change', () => coursesFilter.submit());
            if (semesterSelect) semesterSelect.addEventListener('change', () => coursesFilter.submit());
        }
    </script>
</body>
</html>

