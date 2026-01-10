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

// Get student data
$sql = "SELECT s.*, p.program_name, p.program_code 
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

// Get all programs for dropdown
$programs_result = db_query($conn, "SELECT program_id, program_code, program_name FROM programs ORDER BY program_name", '', []);
$programs = $programs_result ? db_fetch_all($programs_result) : [];

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $first_name = trim($_POST['first_name'] ?? '');
    $middle_name = trim($_POST['middle_name'] ?? '');
    $last_name = trim($_POST['last_name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $date_of_birth = $_POST['date_of_birth'] ?? '';
    $gender = $_POST['gender'] ?? '';
    $address = trim($_POST['address'] ?? '');
    $phone = trim($_POST['phone'] ?? '');
    $program_id = intval($_POST['program_id'] ?? 0);
    $year_level = intval($_POST['year_level'] ?? 1);
    $status = $_POST['status'] ?? 'Active';
    
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
    if (!in_array($status, ['Active', 'Inactive', 'Graduated'])) $errors[] = 'Invalid status';
    
    // Check for duplicate email (excluding current student)
    if (empty($errors)) {
        $check_email = db_query($conn, "SELECT student_id FROM students WHERE email = ? AND student_id != ?", 'si', [$email, $student_id]);
        if ($check_email && $check_email->num_rows > 0) {
            $errors[] = 'Email already exists for another student';
        }
    }
    
    if (empty($errors)) {
        $update_sql = "UPDATE students SET 
                       first_name = ?, middle_name = ?, last_name = ?, email = ?, 
                       date_of_birth = ?, gender = ?, address = ?, phone = ?, 
                       program_id = ?, year_level = ?, status = ?
                       WHERE student_id = ?";
        $stmt = $conn->prepare($update_sql);
        if ($stmt) {
            $stmt->bind_param('ssssssssiisi', $first_name, $middle_name, $last_name, $email, 
                              $date_of_birth, $gender, $address, $phone, 
                              $program_id, $year_level, $status, $student_id);
            if ($stmt->execute()) {
                $message = 'Student information updated successfully!';
                $message_type = 'success';
                // Refresh student data
                $result = db_query($conn, $sql, 'i', [$student_id]);
                $student = db_fetch_one($result);
            } else {
                $message = 'Error updating student: ' . $stmt->error;
                $message_type = 'error';
            }
            $stmt->close();
        } else {
            $message = 'Error preparing update: ' . $conn->error;
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
    <title>Edit Student - <?php echo htmlspecialchars($student['first_name'] . ' ' . $student['last_name']); ?></title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/details.css">
    <style>
        .edit-student-form {
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
        .form-group input:disabled {
            background: #e9ecef;
            cursor: not-allowed;
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
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
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
        .required {
            color: #dc3545;
        }
        .student-number-display {
            background: #e9ecef;
            padding: 10px 12px;
            border-radius: 6px;
            font-weight: 600;
            color: #495057;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Edit Student</h1>
            <div class="header-actions">
                <a href="../index.php" class="btn btn-back">← Back to Student List</a>
                <a href="student_personal.php?id=<?php echo $student_id; ?>" class="btn btn-info">View Info</a>
                <a href="student_grades.php?id=<?php echo $student_id; ?>" class="btn btn-grades">Grades</a>
            </div>
        </header>

        <?php if ($message): ?>
            <div class="message <?php echo $message_type; ?>">
                <?php echo $message; ?>
            </div>
        <?php endif; ?>

        <div class="student-details">
            <form method="post" class="edit-student-form">
                <!-- Student Number (Read-only) -->
                <div class="form-section">
                    <h3>Student Identification</h3>
                    <div class="form-group">
                        <label>Student Number</label>
                        <div class="student-number-display"><?php echo htmlspecialchars($student['student_number']); ?></div>
                    </div>
                </div>

                <!-- Personal Information -->
                <div class="form-section">
                    <h3>Personal Information</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="first_name">First Name <span class="required">*</span></label>
                            <input type="text" id="first_name" name="first_name" value="<?php echo htmlspecialchars($student['first_name']); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="middle_name">Middle Name</label>
                            <input type="text" id="middle_name" name="middle_name" value="<?php echo htmlspecialchars($student['middle_name'] ?? ''); ?>">
                        </div>
                        <div class="form-group">
                            <label for="last_name">Last Name <span class="required">*</span></label>
                            <input type="text" id="last_name" name="last_name" value="<?php echo htmlspecialchars($student['last_name']); ?>" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address <span class="required">*</span></label>
                            <input type="email" id="email" name="email" value="<?php echo htmlspecialchars($student['email']); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" value="<?php echo htmlspecialchars($student['phone'] ?? ''); ?>">
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="date_of_birth">Date of Birth <span class="required">*</span></label>
                            <input type="date" id="date_of_birth" name="date_of_birth" value="<?php echo htmlspecialchars($student['date_of_birth']); ?>" required>
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender <span class="required">*</span></label>
                            <select id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male" <?php echo $student['gender'] === 'Male' ? 'selected' : ''; ?>>Male</option>
                                <option value="Female" <?php echo $student['gender'] === 'Female' ? 'selected' : ''; ?>>Female</option>
                                <option value="Other" <?php echo $student['gender'] === 'Other' ? 'selected' : ''; ?>>Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea id="address" name="address"><?php echo htmlspecialchars($student['address'] ?? ''); ?></textarea>
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
                                    <option value="<?php echo $prog['program_id']; ?>" <?php echo $student['program_id'] == $prog['program_id'] ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($prog['program_code'] . ' - ' . $prog['program_name']); ?>
                                    </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="year_level">Year Level <span class="required">*</span></label>
                            <select id="year_level" name="year_level" required>
                                <option value="1" <?php echo $student['year_level'] == 1 ? 'selected' : ''; ?>>1st Year</option>
                                <option value="2" <?php echo $student['year_level'] == 2 ? 'selected' : ''; ?>>2nd Year</option>
                                <option value="3" <?php echo $student['year_level'] == 3 ? 'selected' : ''; ?>>3rd Year</option>
                                <option value="4" <?php echo $student['year_level'] == 4 ? 'selected' : ''; ?>>4th Year</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="status">Status <span class="required">*</span></label>
                            <select id="status" name="status" required>
                                <option value="Active" <?php echo $student['status'] === 'Active' ? 'selected' : ''; ?>>Active</option>
                                <option value="Inactive" <?php echo $student['status'] === 'Inactive' ? 'selected' : ''; ?>>Inactive</option>
                                <option value="Graduated" <?php echo $student['status'] === 'Graduated' ? 'selected' : ''; ?>>Graduated</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="student_personal.php?id=<?php echo $student_id; ?>" class="btn btn-back">Cancel</a>
                    <button type="submit" class="btn btn-add">Save Changes</button>
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

        // Add loading spinner to forms
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function() {
                showSpinner();
            });
        });
    </script>
</body>
</html>
