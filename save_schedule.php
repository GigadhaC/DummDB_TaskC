<?php
require_once('db-connect.php');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo "<script> alert('Error: No data to save.'); location.replace('./') </script>";
    $conn->close();
    exit;
}

// Define an array of required fields
$requiredFields = ['title', 'description', 'created', 'duedatetime'];

// Check if all required fields are present in $_POST
$missingFields = [];
foreach ($requiredFields as $field) {
    if (!isset($_POST[$field]) || empty($_POST[$field])) {
        $missingFields[] = $field;
    }
}

if (!empty($missingFields)) {
    echo "<script> alert('Error: Required fields (" . implode(', ', $missingFields) . ") are missing.'); location.replace('./') </script>";
    $conn->close();
    exit;
}

// Check if the calendar_id exists in the calendar table
$stmt = $conn->prepare("SELECT calendar_id FROM calendar WHERE calendar_id = ?");
$stmt->bind_param("i", $calendar_id);
$stmt->execute();
$result = $stmt->get_result();
$row_count = $result->num_rows;
$stmt->close();

if ($row_count > 0) {
    // Calendar ID exists, proceed with saving task
    if (empty($_POST['id'])) {
        $sql = "INSERT INTO `task` (`task_title`, `task_description`, `task_created`, `task_duedatetime`, `calendar_id`) VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssi", $title, $description, $created, $duedatetime, $calendar_id);
    } else {
        $id = $_POST['id'];
        $sql = "UPDATE `task` SET `task_title` = ?, `task_description` = ?, `task_created` = ?, `task_duedatetime` = ? WHERE `task_id` = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ssssi", $title, $description, $created, $duedatetime, $id);
    }

    $save = $stmt->execute();
    $stmt->close();

    if ($save) {
        echo "<script> alert('Schedule Successfully Saved.'); location.replace('./') </script>";
    } else {
        echo "<pre>";
        echo "An Error occurred.<br>";
        echo "Error: " . $conn->error . "<br>";
        echo "SQL: " . $sql . "<br>";
        echo "</pre>";
    }
} else {
    echo "<script> alert('Error: Calendar ID does not exist.'); location.replace('./') </script>";
}

$conn->close();
?>
