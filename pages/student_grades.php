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

// Get enrollments with grades for this student
$grades_sql = "SELECT e.*, c.course_code, c.course_name, c.units, c.year_level, c.semester
               FROM enrollments e
               JOIN curriculum c ON e.curriculum_id = c.curriculum_id
               WHERE e.student_id = ?";
$params = [$student_id];
$types = 'i';

if ($selected_year > 0) {
    $grades_sql .= " AND c.year_level = ?";
    $params[] = $selected_year;
    $types .= 'i';
}
if ($selected_semester > 0) {
    $grades_sql .= " AND c.semester = ?";
    $params[] = $selected_semester;
    $types .= 'i';
}
$grades_sql .= " ORDER BY c.year_level, c.semester, c.course_code";
$grades_result = db_query($conn, $grades_sql, $types, $params);
$grades = $grades_result ? db_fetch_all($grades_result) : [];

// Calculate GWA (General Weighted Average) if there are completed courses
$total_units = 0;
$total_grade_points = 0;
$completed_count = 0;
foreach ($grades as $grade) {
    if ($grade['status'] === 'Completed' && $grade['final_grade'] !== null) {
        $total_units += $grade['units'];
        $total_grade_points += ($grade['final_grade'] * $grade['units']);
        $completed_count++;
    }
}
$gwa = $total_units > 0 ? round($total_grade_points / $total_units, 2) : null;

$conn->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Grades - <?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/details.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Student Grades</h1>
            <div class="header-actions">
                <a href="../index.php" class="btn btn-back">← Back to Student List</a>
                <a href="student_personal.php?id=<?php echo $student_id; ?>" class="btn btn-info">Personal Info</a>
                <a href="student_schedules.php?id=<?php echo $student_id; ?>" class="btn btn-schedule">Schedules</a>
                <a href="edit_grades.php?id=<?php echo $student_id; ?>" class="btn btn-edit">Edit Grades</a>
            </div>
        </header>
        
        <div class="student-header">
            <div class="student-name"><?php echo htmlspecialchars($student['last_name'] . ', ' . $student['first_name'] . ' ' . ($student['middle_name'] ?? '')); ?></div>
            <div class="student-info-summary">
                <span class="info-item"><strong>Student No:</strong> <?php echo htmlspecialchars($student['student_number']); ?></span>
                <span class="info-item"><strong>Program:</strong> <?php echo htmlspecialchars($student['program_code'] . ' - ' . $student['program_name']); ?></span>
                <span class="info-item"><strong>Year Level:</strong> <?php echo htmlspecialchars($student['year_level']); ?></span>
                <?php if ($gwa !== null): ?>
                <span class="info-item"><strong>GWA:</strong> <span class="gwa-value"><?php echo number_format($gwa, 2); ?></span></span>
                <?php endif; ?>
            </div>
        </div>

        <div class="filter-section">
            <form method="get" class="filter-form">
                <input type="hidden" name="id" value="<?php echo $student_id; ?>">
                <label for="yearFilter">Year Level:</label>
                <select id="yearFilter" name="year" class="sort-select">
                    <option value="0" <?php echo $selected_year === 0 ? 'selected' : ''; ?>>All Years</option>
                    <?php for ($y = 1; $y <= 4; $y++): ?>
                        <option value="<?php echo $y; ?>" <?php echo $selected_year === $y ? 'selected' : ''; ?>>Year <?php echo $y; ?></option>
                    <?php endfor; ?>
                </select>
                <label for="semesterFilter">Semester:</label>
                <select id="semesterFilter" name="semester" class="sort-select">
                    <option value="0" <?php echo $selected_semester === 0 ? 'selected' : ''; ?>>All Semesters</option>
                    <option value="1" <?php echo $selected_semester === 1 ? 'selected' : ''; ?>>1st Semester</option>
                    <option value="2" <?php echo $selected_semester === 2 ? 'selected' : ''; ?>>2nd Semester</option>
                </select>
                <button type="submit" class="btn">Filter</button>
            </form>
        </div>

        <div class="section">
            <?php if (empty($grades)): ?>
                <p class="no-data">No grades found for this student<?php echo $selected_year > 0 ? ' for the selected filters' : ''; ?>.</p>
            <?php else: ?>
                <?php
                // Group grades by year and semester
                $grouped_grades = [];
                foreach ($grades as $grade) {
                    $key = 'Year ' . $grade['year_level'] . ' - Semester ' . $grade['semester'];
                    if (!isset($grouped_grades[$key])) {
                        $grouped_grades[$key] = [
                            'year_level' => $grade['year_level'],
                            'semester' => $grade['semester'],
                            'courses' => []
                        ];
                    }
                    $grouped_grades[$key]['courses'][] = $grade;
                }
                ?>
                
                <?php foreach ($grouped_grades as $group_name => $group): ?>
                    <h3 class="section-title"><?php echo htmlspecialchars($group_name); ?></h3>
                    <table class="info-table grades-table">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Units</th>
                                <th>Midterm</th>
                                <th>Final</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($group['courses'] as $grade): ?>
                                <tr class="grade-row <?php echo strtolower($grade['status']); ?>">
                                    <td><?php echo htmlspecialchars($grade['course_code']); ?></td>
                                    <td><?php echo htmlspecialchars($grade['course_name']); ?></td>
                                    <td class="center"><?php echo htmlspecialchars($grade['units']); ?></td>
                                    <td class="center grade-cell <?php echo getGradeClass($grade['midterm_grade']); ?>">
                                        <?php echo $grade['midterm_grade'] !== null ? number_format($grade['midterm_grade'], 2) : '-'; ?>
                                    </td>
                                    <td class="center grade-cell <?php echo getGradeClass($grade['final_grade']); ?>">
                                        <?php echo $grade['final_grade'] !== null ? number_format($grade['final_grade'], 2) : '-'; ?>
                                    </td>
                                    <td class="center">
                                        <span class="status-badge status-<?php echo strtolower($grade['status']); ?>">
                                            <?php echo htmlspecialchars($grade['status']); ?>
                                        </span>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                        <tfoot>
                            <?php
                            $sem_units = 0;
                            $sem_grade_points = 0;
                            foreach ($group['courses'] as $g) {
                                if ($g['status'] === 'Completed' && $g['final_grade'] !== null) {
                                    $sem_units += $g['units'];
                                    $sem_grade_points += ($g['final_grade'] * $g['units']);
                                }
                            }
                            $sem_gwa = $sem_units > 0 ? round($sem_grade_points / $sem_units, 2) : null;
                            ?>
                            <tr class="semester-summary">
                                <td colspan="2" class="right"><strong>Semester Total:</strong></td>
                                <td class="center"><strong><?php echo array_sum(array_column($group['courses'], 'units')); ?></strong></td>
                                <td class="center">-</td>
                                <td class="center">
                                    <?php if ($sem_gwa !== null): ?>
                                        <strong><?php echo number_format($sem_gwa, 2); ?></strong>
                                    <?php else: ?>
                                        <em>-</em>
                                    <?php endif; ?>
                                </td>
                                <td class="center">
                                    <?php if ($sem_gwa !== null): ?>
                                        <span class="gwa-label">GWA</span>
                                    <?php else: ?>
                                        <em>In Progress</em>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                <?php endforeach; ?>
                
                <?php if ($gwa !== null && ($selected_year === 0 || count($grouped_grades) > 1)): ?>
                    <div class="gwa-summary">
                        <strong>Cumulative GWA: <?php echo number_format($gwa, 2); ?></strong>
                        <span class="gwa-note">(Based on <?php echo $completed_count; ?> completed courses, <?php echo $total_units; ?> total units)</span>
                    </div>
                <?php endif; ?>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
<?php
// Helper function to get CSS class based on grade
function getGradeClass($grade) {
    if ($grade === null) return '';
    if ($grade <= 1.25) return 'grade-excellent';
    if ($grade <= 1.75) return 'grade-good';
    if ($grade <= 2.50) return 'grade-average';
    if ($grade <= 3.00) return 'grade-pass';
    return 'grade-fail';
}
?>
