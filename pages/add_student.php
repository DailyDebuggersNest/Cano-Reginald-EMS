<?php
require_once '../config/db_helpers.php';

$conn = getDBConnection();
$message = '';
$message_type = '';

// Get all programs for dropdown
$programs_result = db_query($conn, "SELECT program_id, program_code, program_name FROM programs ORDER BY program_name", '', []);
$programs = $programs_result ? db_fetch_all($programs_result) : [];

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $first_name = trim($_POST['first_name'] ?? '');
    $last_name = trim($_POST['last_name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $date_of_birth = $_POST['date_of_birth'] ?? '';
    $gender = $_POST['gender'] ?? '';
    $address = trim($_POST['address'] ?? '');
    $phone = trim($_POST['phone'] ?? '');
    $program_id = intval($_POST['program_id'] ?? 0);
    $year_level = intval($_POST['year_level'] ?? 1);
    $enroll_semester = intval($_POST['enroll_semester'] ?? 1);
    $academic_year = $_POST['academic_year'] ?? '2025-2026';
    
    // Validation
    $errors = [];
    if (empty($first_name)) $errors[] = 'First name is required';
    if (empty($last_name)) $errors[] = 'Last name is required';
    if (empty($email)) $errors[] = 'Email is required';
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = 'Invalid email format';
    if (empty($date_of_birth)) $errors[] = 'Date of birth is required';
    if (empty($gender)) $errors[] = 'Gender is required';
    if ($program_id <= 0) $errors[] = 'Please select a program';
    if ($year_level < 1 || $year_level > 4) $errors[] = 'Invalid year level';
    if ($enroll_semester < 1 || $enroll_semester > 2) $errors[] = 'Invalid semester';
    
    // Check for duplicate email
    if (empty($errors)) {
        $check_email = db_query($conn, "SELECT student_id FROM students WHERE email = ?", 's', [$email]);
        if ($check_email && $check_email->num_rows > 0) {
            $errors[] = 'Email already exists';
        }
    }
    
    if (empty($errors)) {
        // Start transaction
        $conn->begin_transaction();
        
        try {
            // Generate student number (format: YYYY-XXXXX)
            $year_prefix = date('Y');
            $count_result = db_query($conn, "SELECT COUNT(*) as cnt FROM students WHERE student_number LIKE ?", 's', [$year_prefix . '%']);
            $count = db_fetch_one($count_result)['cnt'] ?? 0;
            $student_number = $year_prefix . '-' . str_pad($count + 1, 5, '0', STR_PAD_LEFT);
            
            // Insert student (middle_name is optional)
            $middle_name = ''; // Empty middle name for now
            $insert_sql = "INSERT INTO students (student_number, first_name, middle_name, last_name, email, date_of_birth, gender, address, phone, program_id, year_level, status) 
                           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Active')";
            $stmt = $conn->prepare($insert_sql);
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param('sssssssssii', $student_number, $first_name, $middle_name, $last_name, $email, $date_of_birth, $gender, $address, $phone, $program_id, $year_level);
            $stmt->execute();
            $new_student_id = $conn->insert_id;
            $stmt->close();
            
            // Get ALL curriculum courses for the selected program (all years and semesters)
            // This creates empty enrollments so grade entry works for all semesters
            $curriculum_sql = "SELECT curriculum_id, year_level, semester FROM curriculum WHERE program_id = ? ORDER BY year_level, semester";
            $curriculum_result = db_query($conn, $curriculum_sql, 'i', [$program_id]);
            $courses = $curriculum_result ? db_fetch_all($curriculum_result) : [];
            
            // Enroll student in all courses for their program
            // Courses in/before current semester are 'Enrolled', future ones are 'Enrolled' (ready for grades)
            $enroll_sql = "INSERT INTO enrollments (student_id, curriculum_id, academic_year, status) VALUES (?, ?, ?, 'Enrolled')";
            $enroll_stmt = $conn->prepare($enroll_sql);
            
            foreach ($courses as $course) {
                // Calculate academic year based on course year level
                $course_academic_year = (date('Y') - $year_level + $course['year_level']) . '-' . (date('Y') - $year_level + $course['year_level'] + 1);
                $enroll_stmt->bind_param('iis', $new_student_id, $course['curriculum_id'], $course_academic_year);
                $enroll_stmt->execute();
            }
            $enroll_stmt->close();
            
            $conn->commit();
            
            // Redirect to index with success message
            $conn->close();
            header('Location: ../index.php?msg=added&name=' . urlencode($first_name . ' ' . $last_name));
            exit;
            
        } catch (Exception $e) {
            $conn->rollback();
            $message = 'Error adding student: ' . $e->getMessage();
            $message_type = 'error';
        }
    } else {
        $message = implode('<br>', $errors);
        $message_type = 'error';
    }
}

$conn->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Student</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/details.css">
    <style>
        .add-student-form {
            max-width: 700px;
            margin: 0 auto;
        }
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            flex: 1;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            color: #495057;
            font-size: 14px;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #0066cc;
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        .form-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }
        .form-section h3 {
            margin: 0 0 15px 0;
            font-size: 16px;
            color: #343a40;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 10px;
        }
        .form-actions .btn {
            padding: 12px 30px;
            font-size: 15px;
        }
        .message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
        }
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        .enrollment-info {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 6px;
            margin-top: 10px;
            font-size: 13px;
            color: #004085;
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Add New Student</h1>
            <div class="header-actions">
                <a href="../index.php" class="btn btn-back">← Back to Student List</a>
            </div>
        </header>

        <?php if ($message): ?>
            <div class="message <?php echo $message_type; ?>">
                <?php echo $message; ?>
            </div>
        <?php endif; ?>

        <div class="student-details">
            <form method="post" class="add-student-form">
                <!-- Personal Information -->
                <div class="form-section">
                    <h3>Personal Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="first_name">First Name <span class="required">*</span></label>
                            <input type="text" id="first_name" name="first_name" value="<?php echo htmlspecialchars($first_name ?? ''); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="last_name">Last Name <span class="required">*</span></label>
                            <input type="text" id="last_name" name="last_name" value="<?php echo htmlspecialchars($last_name ?? ''); ?>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address <span class="required">*</span></label>
                            <input type="email" id="email" name="email" value="<?php echo htmlspecialchars($email ?? ''); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<?php echo htmlspecialchars($phone ?? ''); ?>">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="date_of_birth">Date of Birth <span class="required">*</span></label>
                            <input type="date" id="date_of_birth" name="date_of_birth" value="<?php echo htmlspecialchars($date_of_birth ?? ''); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender <span class="required">*</span></label>
                            <select id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male" <?php echo ($gender ?? '') === 'Male' ? 'selected' : ''; ?>>Male</option>
                                <option value="Female" <?php echo ($gender ?? '') === 'Female' ? 'selected' : ''; ?>>Female</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address"><?php echo htmlspecialchars($address ?? ''); ?></textarea>
                    </div>
                </div>

                <!-- Academic Information -->
                <div class="form-section">
                    <h3>Academic Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="program_id">Program <span class="required">*</span></label>
                            <select id="program_id" name="program_id" required>
                                <option value="">Select Program</option>
                                <?php foreach ($programs as $prog): ?>
                                    <option value="<?php echo $prog['program_id']; ?>" <?php echo ($program_id ?? 0) == $prog['program_id'] ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($prog['program_code'] . ' - ' . $prog['program_name']); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="academic_year">Academic Year <span class="required">*</span></label>
                            <select id="academic_year" name="academic_year" required>
                                <option value="2025-2026" selected>2025-2026</option>
                                <option value="2024-2025">2024-2025</option>
                                <option value="2026-2027">2026-2027</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="year_level">Year Level <span class="required">*</span></label>
                            <select id="year_level" name="year_level" required>
                                <option value="1" <?php echo ($year_level ?? 1) == 1 ? 'selected' : ''; ?>>1st Year</option>
                                <option value="2" <?php echo ($year_level ?? 1) == 2 ? 'selected' : ''; ?>>2nd Year</option>
                                <option value="3" <?php echo ($year_level ?? 1) == 3 ? 'selected' : ''; ?>>3rd Year</option>
                                <option value="4" <?php echo ($year_level ?? 1) == 4 ? 'selected' : ''; ?>>4th Year</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="enroll_semester">Enroll in Semester <span class="required">*</span></label>
                            <select id="enroll_semester" name="enroll_semester" required>
                                <option value="1" <?php echo ($enroll_semester ?? 1) == 1 ? 'selected' : ''; ?>>1st Semester</option>
                                <option value="2" <?php echo ($enroll_semester ?? 1) == 2 ? 'selected' : ''; ?>>2nd Semester</option>
                            </select>
                        </div>
                    </div>
                    <div class="enrollment-info">
                        <strong>Auto-Enrollment:</strong> The student will be automatically enrolled in ALL courses for their 4-year program (64 courses, 192 units). This allows grade entry for any semester. The "Current Semester" selection is for record-keeping purposes.
                    </div>
                </div>

                <div class="form-actions">
                    <a href="../index.php" class="btn btn-back">Cancel</a>
                    <button type="submit" class="btn btn-add" onclick="return confirmAdd()">Add Student & Enroll</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div class="spinner-overlay" id="loadingSpinner">
        <div class="spinner"></div>
    </div>

    <script>
        // Loading spinner
        function showSpinner() {
            document.getElementById('loadingSpinner').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function confirmAdd() {
            const firstName = document.getElementById('first_name').value.trim();
            const lastName = document.getElementById('last_name').value.trim();
            const program = document.getElementById('program_id');
            const programText = program.options[program.selectedIndex]?.text || 'Selected Program';
            const yearLevel = document.getElementById('year_level').value;
            const semester = document.getElementById('enroll_semester').value;
            
            if (!firstName || !lastName) {
                return true; // Let form validation handle it
            }
            
            const message = `Are you sure you want to add the following student?\n\n` +
                `Name: ${firstName} ${lastName}\n` +
                `Program: ${programText}\n` +
                `Year Level: ${yearLevel}\n` +
                `Current Semester: ${semester}\n\n` +
                `The student will be enrolled in all 64 courses (192 units) for their 4-year program.`;
            
            const confirmed = confirm(message);
            if (confirmed) {
                showSpinner();
            }
            return confirmed;
        }
    </script>
</body>
</html>
