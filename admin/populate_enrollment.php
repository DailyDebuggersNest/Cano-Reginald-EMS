<?php
require_once __DIR__ . '/../config/database.php';

$message = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $conn = getDBConnection();
    if (!$conn) {
        $message = 'DB connection failed.';
    } else {
        // determine current semester based on current month
        $month = intval(date('n'));
        $currentSemester = ($month >= 1 && $month <= 6) ? 1 : 2;

        // Prepare statements
        $enroll_check = $conn->prepare("SELECT enrollment_id FROM enrollment WHERE student_id = ? AND year_level = ? AND semester = ? LIMIT 1");
        $enroll_insert = $conn->prepare("INSERT INTO enrollment (student_id, curriculum_id, year_level, semester, status, enrolled_at) VALUES (?, ?, ?, ?, ?, NOW())");

        $stu_res = $conn->query("SELECT student_id, curriculum_id, year_level FROM student");
        $inserted = 0;
        if ($stu_res) {
            while ($stu = $stu_res->fetch_assoc()) {
                $student_id = intval($stu['student_id']);
                $curriculum_id = intval($stu['curriculum_id']);
                $stud_year_level = intval($stu['year_level']);
                if ($stud_year_level < 1) $stud_year_level = 1;

                for ($y = 1; $y <= $stud_year_level; $y++) {
                    $sem_max = ($y < $stud_year_level) ? 2 : $currentSemester;
                    for ($s = 1; $s <= $sem_max; $s++) {
                        $enroll_check->bind_param('iii', $student_id, $y, $s);
                        $enroll_check->execute();
                        $res = $enroll_check->get_result();
                        if ($res && $res->num_rows > 0) continue;

                        if ($y < $stud_year_level || ($y == $stud_year_level && $s < $currentSemester)) {
                            $status = 'Completed';
                        } else {
                            $status = 'Enrolled';
                        }
                        $enroll_insert->bind_param('iiiss', $student_id, $curriculum_id, $y, $s, $status);
                        if ($enroll_insert->execute()) $inserted++;
                    }
                }
            }
        }

        $enroll_check->close();
        $enroll_insert->close();
        $conn->close();
        $message = "Finished. Enrollment rows inserted: $inserted";
    }
}
?>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Populate Enrollments</title>
    <link rel="stylesheet" href="/student_system21/css/common.css">
</head>
<body>
    <div class="container">
        <h1>Populate Enrollment Rows</h1>
        <p>This will create `enrollment` records for each student for every year (1..student.year_level) and semester up to current semester. It is idempotent.</p>
        <?php if ($message): ?>
            <div class="notice"><?php echo htmlspecialchars($message); ?></div>
        <?php endif; ?>
        <form method="post">
            <button class="btn btn-primary" type="submit">Run Population</button>
        </form>
        <p><a href="../index.php">Back to index</a></p>
    </div>
    </body>
</html>
