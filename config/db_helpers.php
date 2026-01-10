<?php
// filepath: config/db_helpers.php
// Common database helper functions for prepared queries and fetches
require_once __DIR__ . '/database.php';

/**
 * Prepare and execute a query, return result or false.
 * @param mysqli $conn
 * @param string $sql
 * @param string $types
 * @param array $params
 * @return mysqli_result|false
 */
function db_query($conn, $sql, $types = '', $params = []) {
    $stmt = $conn->prepare($sql);
    if (!$stmt) return false;
    if ($types && $params) {
        $stmt->bind_param($types, ...$params);
    }
    if (!$stmt->execute()) {
        $stmt->close();
        return false;
    }
    $result = $stmt->get_result();
    $stmt->close();
    return $result;
}

/**
 * Fetch all rows from a result as an array
 * @param mysqli_result $result
 * @return array
 */
function db_fetch_all($result) {
    $rows = [];
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
    }
    return $rows;
}

/**
 * Fetch a single row from a result
 * @param mysqli_result $result
 * @return array|null
 */
function db_fetch_one($result) {
    if ($result && $row = $result->fetch_assoc()) {
        return $row;
    }
    return null;
}
