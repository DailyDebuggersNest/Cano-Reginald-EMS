<?php
session_start();
include 'database.php';

if (!isset($_SESSION['show_table'])) {
    $_SESSION['show_table'] = false;
}

if (isset($_POST['toggle_table'])) {
    $_SESSION['show_table'] = !$_SESSION['show_table'];
    header('Location: ' . $_SERVER['PHP_SELF'] . (isset($_GET['sort']) ? '?sort=' . urlencode($_GET['sort']) : ''));
    exit;
}

$sortOption = isset($_GET['sort']) && strtolower($_GET['sort']) === 'asc' ? 'ASC' : 'DESC';
$query = "
    SELECT s.id, s.firstname, s.lastname, c.course_code, c.course_name
    FROM students AS s
    JOIN courses AS c ON s.course_id = c.id
    ORDER BY s.id {$sortOption}
";
$result = mysqli_query($conn, $query);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students</title>
    <link rel="stylesheet" href="assets/index.css">
</head>
<body>
    <div class="page">
        <form method="post" class="center-btn">
            <button type="submit" name="toggle_table">
                <?= $_SESSION['show_table'] ? 'Hide Students' : 'Show Students' ?>
            </button>
        </form>

        <?php if ($_SESSION['show_table']): ?>
            <form method="get" class="sort-form">
                <label for="sort">Sort by ID:</label>
                <select name="sort" id="sort" onchange="this.form.submit()">
                    <option value="desc" <?= ($sortOption === 'DESC') ? 'selected' : '' ?>>Newest first (DESC)</option>
                    <option value="asc" <?= ($sortOption === 'ASC') ? 'selected' : '' ?>>Oldest first (ASC)</option>
                </select>
                <noscript><button type="submit">Apply</button></noscript>
            </form>
            <div class="table-wrap">
                <?php if ($result && mysqli_num_rows($result) > 0): ?>
                    <table class="student-table">
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Course</th>
                        </tr>
                        <?php while ($row = mysqli_fetch_assoc($result)):
                            $fullName = $row['lastname'] . ', ' . $row['firstname'];
                            $fullCourse = $row['course_code'] . ' - ' . $row['course_name'];
                        ?>
                            <tr>
                                <td><?= htmlspecialchars($row['id']) ?></td>
                                <td>
                                    <a href="student.php?id=<?= urlencode($row['id']) ?>">
                                        <?= htmlspecialchars($fullName) ?>
                                    </a>
                                </td>
                                <td><?= htmlspecialchars($fullCourse) ?></td>
                            </tr>
                        <?php endwhile; ?>
                    </table>
                <?php else: ?>
                    <p>No records found.</p>
                <?php endif; ?>
            </div>
        <?php endif; ?>
    </div>
</body>
</html>
