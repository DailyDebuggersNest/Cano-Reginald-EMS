<?php
require_once 'config/db_helpers.php';

// Handle notification messages
$notification = '';
$notification_type = '';
if (isset($_GET['msg'])) {
    switch ($_GET['msg']) {
        case 'dropped':
            $notification = 'Student "' . htmlspecialchars($_GET['name'] ?? '') . '" has been successfully dropped.';
            $notification_type = 'success';
            break;
        case 'added':
            $notification = 'Student "' . htmlspecialchars($_GET['name'] ?? '') . '" has been successfully added.';
            $notification_type = 'success';
            break;
        case 'notfound':
            $notification = 'Student not found.';
            $notification_type = 'error';
            break;
        case 'error':
            $notification = 'An error occurred. Please try again.';
            $notification_type = 'error';
            break;
    }
}

$view = isset($_GET['view']) ? $_GET['view'] : 'students';

$sort_field = isset($_GET['sort_field']) ? $_GET['sort_field'] : 'last_name';
$sort_order = isset($_GET['sort_order']) ? $_GET['sort_order'] : 'asc';
$allowed_fields = ['last_name', 'student_number', 'year_level', 'program'];
if (!in_array($sort_field, $allowed_fields)) {
    $sort_field = 'last_name';
}
$sort_order = ($sort_order === 'asc' || $sort_order === 'desc') ? $sort_order : 'asc';

// Program filter
$filter_program = isset($_GET['filter_program']) ? intval($_GET['filter_program']) : 0;

// Pagination settings
$items_per_page = 10;
$current_page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
$offset = ($current_page - 1) * $items_per_page;

// Search parameter
$search = isset($_GET['search']) ? trim($_GET['search']) : '';
$filter_condition = '';
$filter_params = [];
$filter_types = '';

// Build filter conditions
$conditions = [];
if (!empty($search)) {
    $search_like = '%' . $search . '%';
    $conditions[] = "(s.first_name LIKE ? OR s.last_name LIKE ? OR s.student_number LIKE ? OR s.email LIKE ? OR p.program_code LIKE ?)";
    $filter_params = array_merge($filter_params, [$search_like, $search_like, $search_like, $search_like, $search_like]);
    $filter_types .= 'sssss';
}
if ($filter_program > 0) {
    $conditions[] = "s.program_id = ?";
    $filter_params[] = $filter_program;
    $filter_types .= 'i';
}
if (!empty($conditions)) {
    $filter_condition = " WHERE " . implode(' AND ', $conditions);
}

$conn = getDBConnection();

// --- Count total students for pagination ---
$count_sql = "SELECT COUNT(*) as total FROM students s LEFT JOIN programs p ON s.program_id = p.program_id" . $filter_condition;
if (!empty($filter_params)) {
    $count_result = db_query($conn, $count_sql, $filter_types, $filter_params);
} else {
    $count_result = db_query($conn, $count_sql);
}
$total_students = db_fetch_one($count_result)['total'] ?? 0;
$total_pages = ceil($total_students / $items_per_page);

// --- Prepare students query with pagination ---
$order_by = '';
switch ($sort_field) {
    case 'last_name':
        $order_by = 's.last_name';
        break;
    case 'student_number':
        $order_by = 's.student_number';
        break;
    case 'year_level':
        $order_by = 's.year_level';
        break;
    case 'program':
        $order_by = 'p.program_code, p.program_name';
        break;
    default:
        $order_by = 's.last_name';
}
$students_sql = "SELECT s.*, p.program_name, p.program_code 
        FROM students s 
        LEFT JOIN programs p ON s.program_id = p.program_id" 
        . $filter_condition . "
        ORDER BY $order_by " . ($sort_order === 'asc' ? 'ASC' : 'DESC') . "
        LIMIT $items_per_page OFFSET $offset";
if (!empty($filter_params)) {
    $students_result = db_query($conn, $students_sql, $filter_types, $filter_params);
} else {
    $students_result = db_query($conn, $students_sql);
}

// --- Load programs for selectors ---
$prog_sql = "SELECT program_id, program_code, program_name, description FROM programs ORDER BY program_code";
$prog_res = db_query($conn, $prog_sql);
$programs = db_fetch_all($prog_res);

// --- Curriculum (courses) filters and pagination ---
$curriculum_program = isset($_GET['curriculum_program']) ? intval($_GET['curriculum_program']) : 0;
$curriculum_year = isset($_GET['curriculum_year']) ? intval($_GET['curriculum_year']) : 0;
$curriculum_semester = isset($_GET['curriculum_semester']) ? intval($_GET['curriculum_semester']) : 0;
$curriculum_page = isset($_GET['cpage']) ? max(1, intval($_GET['cpage'])) : 1;
$curriculum_per_page = 15;
$curriculum_offset = ($curriculum_page - 1) * $curriculum_per_page;

// Count total curriculum items
$count_curriculum_sql = "SELECT COUNT(*) as total FROM curriculum c WHERE 1=1";
if ($curriculum_program > 0) {
    $count_curriculum_sql .= " AND c.program_id = $curriculum_program";
}
if ($curriculum_year > 0) {
    $count_curriculum_sql .= " AND c.year_level = $curriculum_year";
}
if ($curriculum_semester > 0) {
    $count_curriculum_sql .= " AND c.semester = $curriculum_semester";
}
$count_curriculum_result = db_query($conn, $count_curriculum_sql);
$total_curriculum = db_fetch_one($count_curriculum_result)['total'] ?? 0;
$total_curriculum_pages = ceil($total_curriculum / $curriculum_per_page);

$curriculum_sql = "SELECT c.*, p.program_code, p.program_name 
                   FROM curriculum c 
                   LEFT JOIN programs p ON c.program_id = p.program_id 
                   WHERE 1=1";
if ($curriculum_program > 0) {
    $curriculum_sql .= " AND c.program_id = $curriculum_program";
}
if ($curriculum_year > 0) {
    $curriculum_sql .= " AND c.year_level = $curriculum_year";
}
if ($curriculum_semester > 0) {
    $curriculum_sql .= " AND c.semester = $curriculum_semester";
}
$curriculum_sql .= " ORDER BY c.program_id, c.year_level, c.semester, c.course_code";
$curriculum_sql .= " LIMIT $curriculum_per_page OFFSET $curriculum_offset";
$curriculum_result = db_query($conn, $curriculum_sql);

// --- Selected program detail ---
$selected_program = isset($_GET['program_id']) ? intval($_GET['program_id']) : 0;
if ($selected_program > 0) {
    $sel_sql = "SELECT program_id, program_code, program_name, description FROM programs WHERE program_id = ?";
    $sel_res = db_query($conn, $sel_sql, 'i', [$selected_program]);
    $sel_prog = db_fetch_one($sel_res);
} else {
    $sel_prog = null;
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/index.css">
</head>
<body>
    <div class="container">
        <header>
            <div class="header-top">
                <h1>Student Management System</h1>
                <button class="hamburger" id="hamburgerBtn" aria-label="Toggle navigation">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
            <?php if ($view === 'students'): ?>
            <div class="header-search">
                <form method="get" class="search-form">
                    <input type="hidden" name="view" value="students">
                    <input type="hidden" name="sort_field" value="<?php echo htmlspecialchars($sort_field); ?>">
                    <input type="hidden" name="sort_order" value="<?php echo htmlspecialchars($sort_order); ?>">
                    <input type="text" name="search" class="search-input" placeholder="Search students..." value="<?php echo htmlspecialchars($search); ?>">
                    <button type="submit" class="btn btn-search">Search</button>
                    <?php if (!empty($search)): ?>
                        <a href="?view=students" class="btn btn-clear">Clear</a>
                    <?php endif; ?>
                </form>
            </div>
            <?php endif; ?>
        </header>

        <nav class="mobile-nav" id="mobileNav">
            <a class="nav-link <?php echo $view === 'students' ? 'active' : ''; ?>" href="?view=students">Students</a>
            <a class="nav-link <?php echo $view === 'programs' ? 'active' : ''; ?>" href="?view=programs">Programs</a>
            <a class="nav-link <?php echo $view === 'curriculum' ? 'active' : ''; ?>" href="?view=curriculum">Curriculum</a>
            <a class="nav-link" href="pages/add_student.php">Add Student</a>
        </nav>

        <div class="controls">
            <div class="view-buttons">
                <a class="btn <?php echo $view === 'students' ? 'btn-primary' : ''; ?>" href="?view=students">Students</a>
                <a class="btn <?php echo $view === 'programs' ? 'btn-primary' : ''; ?>" href="?view=programs">Programs</a>
                <a class="btn <?php echo $view === 'curriculum' ? 'btn-primary' : ''; ?>" href="?view=curriculum">Curriculum</a>
                <a class="btn btn-add" href="pages/add_student.php">+ Add Student</a>
            </div>

            <?php if ($view === 'students'): ?>
                <div class="sort-controls">
                    <label for="filterProgram">Program:</label>
                    <select id="filterProgram" name="filter_program" class="sort-select">
                        <option value="0">All Programs</option>
                        <?php foreach ($programs as $p): ?>
                            <option value="<?php echo $p['program_id']; ?>" <?php echo $filter_program == $p['program_id'] ? 'selected' : ''; ?>><?php echo htmlspecialchars($p['program_code']); ?></option>
                        <?php endforeach; ?>
                    </select>
                    <label for="sortField">Sort by:</label>
                    <select id="sortField" name="sort_field" class="sort-select">
                        <option value="last_name" <?php echo $sort_field === 'last_name' ? 'selected' : ''; ?>>Last Name</option>
                        <option value="student_number" <?php echo $sort_field === 'student_number' ? 'selected' : ''; ?>>Student Number</option>
                        <option value="year_level" <?php echo $sort_field === 'year_level' ? 'selected' : ''; ?>>Year Level</option>
                        <option value="program" <?php echo $sort_field === 'program' ? 'selected' : ''; ?>>Program</option>
                    </select>
                    <select id="sortOrder" name="sort_order" class="sort-select">
                        <option value="asc" <?php echo $sort_order === 'asc' ? 'selected' : ''; ?>>Ascending</option>
                        <option value="desc" <?php echo $sort_order === 'desc' ? 'selected' : ''; ?>>Descending</option>
                    </select>
                </div>
            <?php endif; ?>

            <?php if ($view === 'curriculum'): ?>
                <form method="get" class="filter-form">
                    <input type="hidden" name="view" value="curriculum">
                    <label for="curriculumProgram">Program:</label>
                    <select id="curriculumProgram" name="curriculum_program" class="sort-select">
                        <option value="0">All</option>
                        <?php foreach ($programs as $p): ?>
                            <option value="<?php echo $p['program_id']; ?>" <?php echo $curriculum_program == $p['program_id'] ? 'selected' : ''; ?>><?php echo htmlspecialchars($p['program_code'] . ' - ' . $p['program_name']); ?></option>
                        <?php endforeach; ?>
                    </select>
                    <label for="curriculumYear">Year Level:</label>
                    <select id="curriculumYear" name="curriculum_year" class="sort-select">
                        <option value="0">All</option>
                        <option value="1" <?php echo $curriculum_year == 1 ? 'selected' : ''; ?>>1</option>
                        <option value="2" <?php echo $curriculum_year == 2 ? 'selected' : ''; ?>>2</option>
                        <option value="3" <?php echo $curriculum_year == 3 ? 'selected' : ''; ?>>3</option>
                        <option value="4" <?php echo $curriculum_year == 4 ? 'selected' : ''; ?>>4</option>
                    </select>
                    <label for="curriculumSemester">Semester:</label>
                    <select id="curriculumSemester" name="curriculum_semester" class="sort-select">
                        <option value="0">All</option>
                        <option value="1" <?php echo $curriculum_semester == 1 ? 'selected' : ''; ?>>1st Semester</option>
                        <option value="2" <?php echo $curriculum_semester == 2 ? 'selected' : ''; ?>>2nd Semester</option>
                    </select>
                    <button class="btn">Filter</button>
                </form>
            <?php endif; ?>
        </div>

        <?php if ($view === 'students'): ?>
            <div id="studentTable" class="table-container">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Student No.</th>
                            <th>Last Name</th>
                            <th>First Name</th>
                            <th>Program</th>
                            <th>Year</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        if ($students_result && $students_result->num_rows > 0) {
                            while ($row = $students_result->fetch_assoc()) {
                                $firstName = htmlspecialchars($row['first_name'] . ($row['middle_name'] ? ' ' . substr($row['middle_name'], 0, 1) . '.' : ''));
                                echo "<tr>";
                                echo "<td>" . htmlspecialchars($row['student_number']) . "</td>";
                                echo "<td>" . htmlspecialchars($row['last_name']) . "</td>";
                                echo "<td>" . $firstName . "</td>";
                                echo "<td>" . htmlspecialchars($row['program_code'] ?? 'N/A') . "</td>";
                                echo "<td>" . htmlspecialchars($row['year_level']) . "</td>";
                                echo "<td><span class='status-badge status-" . strtolower($row['status']) . "'>" . htmlspecialchars($row['status']) . "</span></td>";
                                echo "<td class='action-buttons'>";
                                echo "<a class='btn btn-action btn-info' href='pages/student_personal.php?id=" . $row['student_id'] . "' title='View Personal Information'>Info</a>";
                                echo "<a class='btn btn-action btn-edit' href='pages/edit_student.php?id=" . $row['student_id'] . "' title='Edit Student'>Edit</a>";
                                echo "<a class='btn btn-action btn-schedule' href='pages/student_schedules.php?id=" . $row['student_id'] . "' title='View Schedules'>Schedule</a>";
                                echo "<a class='btn btn-action btn-grades' href='pages/student_grades.php?id=" . $row['student_id'] . "' title='View Grades'>Grades</a>";
                                echo "<button class='btn btn-action btn-drop' onclick=\"confirmDrop('" . $row['student_id'] . "', '" . htmlspecialchars($row['last_name'] . ", " . $row['first_name'], ENT_QUOTES) . "')\" title='Drop Student'>Drop</button>";
                                echo "</td>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='7' class='no-data'>No students found.</td></tr>";
                        }
                        ?>
                    </tbody>
                </table>
            </div>

            <?php if ($total_pages > 1): ?>
                <div class="pagination">
                    <span class="pagination-info">Showing <?php echo $offset + 1; ?>-<?php echo min($offset + $items_per_page, $total_students); ?> of <?php echo $total_students; ?> students</span>
                    <div class="pagination-controls">
                        <?php 
                        $pagination_params = "view=students&sort_field=$sort_field&sort_order=$sort_order&filter_program=$filter_program" . (!empty($search) ? "&search=" . urlencode($search) : "");
                        ?>
                        <?php if ($current_page > 1): ?>
                            <a href="?<?php echo $pagination_params; ?>&page=1" class="btn btn-page" title="First">&laquo;</a>
                            <a href="?<?php echo $pagination_params; ?>&page=<?php echo $current_page - 1; ?>" class="btn btn-page" title="Previous">&lsaquo;</a>
                        <?php endif; ?>
                        
                        <?php
                        $start_page = max(1, $current_page - 2);
                        $end_page = min($total_pages, $current_page + 2);
                        for ($p = $start_page; $p <= $end_page; $p++):
                        ?>
                            <a href="?<?php echo $pagination_params; ?>&page=<?php echo $p; ?>" class="btn btn-page <?php echo $p === $current_page ? 'btn-page-active' : ''; ?>"><?php echo $p; ?></a>
                        <?php endfor; ?>
                        
                        <?php if ($current_page < $total_pages): ?>
                            <a href="?<?php echo $pagination_params; ?>&page=<?php echo $current_page + 1; ?>" class="btn btn-page" title="Next">&rsaquo;</a>
                            <a href="?<?php echo $pagination_params; ?>&page=<?php echo $total_pages; ?>" class="btn btn-page" title="Last">&raquo;</a>
                        <?php endif; ?>
                    </div>
                </div>
            <?php endif; ?>
        <?php endif; ?>

        <?php if ($view === 'programs'): ?>
            <div id="programsTable" class="table-container">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Program Code</th>
                            <th>Program Name</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (!empty($programs)): ?>
                            <?php foreach ($programs as $p): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($p['program_code']); ?></td>
                                    <td><?php echo htmlspecialchars($p['program_name']); ?></td>
                                    <td><?php echo htmlspecialchars($p['description'] ?? ''); ?></td>
                                </tr>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <tr><td colspan='3' class='no-data'>No programs found.</td></tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>

        <?php if ($view === 'curriculum'): ?>
            <div id="curriculumTable" class="table-container">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Course Code</th>
                            <th>Course Name</th>
                            <th>Program</th>
                            <th>Units</th>
                            <th>Year</th>
                            <th>Semester</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if ($curriculum_result && $curriculum_result->num_rows > 0): ?>
                            <?php while ($c = $curriculum_result->fetch_assoc()): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($c['course_code']); ?></td>
                                    <td><?php echo htmlspecialchars($c['course_name']); ?></td>
                                    <td><?php echo htmlspecialchars($c['program_code'] ?? ''); ?></td>
                                    <td><?php echo htmlspecialchars($c['units']); ?></td>
                                    <td><?php echo htmlspecialchars($c['year_level']); ?></td>
                                    <td><?php echo htmlspecialchars($c['semester']); ?></td>
                                    <td><?php echo htmlspecialchars($c['description'] ?? ''); ?></td>
                                </tr>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <tr><td colspan='7' class='no-data'>No courses found.</td></tr>
                        <?php endif; ?>
                    </tbody>
                </table>
                
                <!-- Curriculum Pagination -->
                <?php if ($total_curriculum_pages > 1): ?>
                <div class="pagination">
                    <div class="pagination-info">
                        Showing <?php echo $curriculum_offset + 1; ?>-<?php echo min($curriculum_offset + $curriculum_per_page, $total_curriculum); ?> of <?php echo $total_curriculum; ?> courses
                    </div>
                    <div class="pagination-controls">
                        <?php
                        $curriculum_params = $_GET;
                        unset($curriculum_params['cpage']);
                        $curriculum_base_url = '?' . http_build_query($curriculum_params) . '&cpage=';
                        ?>
                        
                        <?php if ($curriculum_page > 1): ?>
                            <a href="<?php echo $curriculum_base_url . '1'; ?>" class="btn-page">&laquo; First</a>
                            <a href="<?php echo $curriculum_base_url . ($curriculum_page - 1); ?>" class="btn-page">&lsaquo; Prev</a>
                        <?php endif; ?>
                        
                        <?php
                        $start_page = max(1, $curriculum_page - 2);
                        $end_page = min($total_curriculum_pages, $curriculum_page + 2);
                        for ($i = $start_page; $i <= $end_page; $i++):
                        ?>
                            <a href="<?php echo $curriculum_base_url . $i; ?>" class="btn-page <?php echo ($i == $curriculum_page) ? 'btn-page-active' : ''; ?>"><?php echo $i; ?></a>
                        <?php endfor; ?>
                        
                        <?php if ($curriculum_page < $total_curriculum_pages): ?>
                            <a href="<?php echo $curriculum_base_url . ($curriculum_page + 1); ?>" class="btn-page">Next &rsaquo;</a>
                            <a href="<?php echo $curriculum_base_url . $total_curriculum_pages; ?>" class="btn-page">Last &raquo;</a>
                        <?php endif; ?>
                    </div>
                </div>
                <?php endif; ?>
            </div>
        <?php endif; ?>

        <?php $conn->close(); ?>
    </div>

    <!-- Toast Notification -->
    <?php if (!empty($notification)): ?>
    <div id="toast" class="toast toast-<?php echo $notification_type; ?>">
        <span class="toast-icon"><?php echo $notification_type === 'success' ? '✓' : '✕'; ?></span>
        <span class="toast-message"><?php echo $notification; ?></span>
        <button class="toast-close" onclick="closeToast()">&times;</button>
    </div>
    <?php endif; ?>

    <!-- Confirmation Modal -->
    <div class="modal-overlay" id="confirmModal">
        <div class="modal">
            <div class="modal-header">
                <h3 id="modalTitle">Confirm Action</h3>
            </div>
            <div class="modal-body">
                <p id="modalMessage">Are you sure you want to proceed?</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn btn-danger" id="modalConfirmBtn" onclick="confirmAction()">Confirm</button>
            </div>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div class="spinner-overlay" id="loadingSpinner">
        <div class="spinner"></div>
    </div>

    <script>
        // Handle sort field, order, and program filter changes
        const sortField = document.getElementById('sortField');
        const sortOrder = document.getElementById('sortOrder');
        const filterProgram = document.getElementById('filterProgram');
        
        function updateSort() {
            const params = new URLSearchParams(window.location.search);
            if (sortField) params.set('sort_field', sortField.value);
            if (sortOrder) params.set('sort_order', sortOrder.value);
            if (filterProgram) params.set('filter_program', filterProgram.value);
            params.set('view', 'students');
            params.delete('page'); // Reset to first page when filtering
            window.location.search = params.toString();
        }
        
        if (sortField) sortField.addEventListener('change', updateSort);
        if (sortOrder) sortOrder.addEventListener('change', updateSort);
        if (filterProgram) filterProgram.addEventListener('change', updateSort);

        // Toast notification
        function closeToast() {
            const toast = document.getElementById('toast');
            if (toast) {
                toast.classList.add('toast-hide');
                setTimeout(() => toast.remove(), 300);
            }
        }

        // Auto-hide toast after 5 seconds
        const toast = document.getElementById('toast');
        if (toast) {
            setTimeout(() => {
                toast.classList.add('toast-hide');
                setTimeout(() => toast.remove(), 300);
            }, 5000);
        }

        // Modal functionality
        let pendingAction = null;

        function showModal(title, message, actionUrl, confirmText = 'Confirm') {
            document.getElementById('modalTitle').textContent = title;
            document.getElementById('modalMessage').textContent = message;
            document.getElementById('modalConfirmBtn').textContent = confirmText;
            pendingAction = actionUrl;
            document.getElementById('confirmModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            document.getElementById('confirmModal').classList.remove('active');
            document.body.style.overflow = '';
            pendingAction = null;
        }

        function confirmAction() {
            if (pendingAction) {
                showSpinner();
                window.location.href = pendingAction;
            }
        }

        // Close modal on outside click
        document.getElementById('confirmModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        // Close modal on Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
        });

        // Loading spinner
        function showSpinner() {
            document.getElementById('loadingSpinner').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function hideSpinner() {
            document.getElementById('loadingSpinner').classList.remove('active');
            document.body.style.overflow = '';
        }

        // Confirm drop action
        function confirmDrop(studentId, studentName) {
            showModal(
                'Drop Student',
                `Are you sure you want to drop ${studentName}? This action cannot be undone.`,
                `pages/drop_student.php?id=${studentId}&confirm=1`,
                'Drop Student'
            );
        }

        // Add loading spinner to forms
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function() {
                showSpinner();
            });
        });

        // Hamburger menu toggle
        const hamburgerBtn = document.getElementById('hamburgerBtn');
        const mobileNav = document.getElementById('mobileNav');
        
        if (hamburgerBtn && mobileNav) {
            hamburgerBtn.addEventListener('click', function() {
                this.classList.toggle('active');
                mobileNav.classList.toggle('active');
            });
        }
    </script>
</body>
</html>

