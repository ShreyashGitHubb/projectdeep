-- Student Attendance Management System
-- Target: MySQL 8.0+
-- Run this complete script in MySQL Workbench.

CREATE DATABASE IF NOT EXISTS student_attendance_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE student_attendance_db;

CREATE TABLE IF NOT EXISTS students (
    student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    roll_no VARCHAR(20) NOT NULL,
    class_name VARCHAR(40) NOT NULL,
    department VARCHAR(80) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(120),
    admission_date DATE,
    PRIMARY KEY (student_id),
    UNIQUE KEY uq_students_roll_no (roll_no),
    UNIQUE KEY uq_students_email (email)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS teachers (
    teacher_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    teacher_name VARCHAR(100) NOT NULL,
    department VARCHAR(80) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(120),
    PRIMARY KEY (teacher_id),
    UNIQUE KEY uq_teachers_email (email)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS subjects (
    subject_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (subject_id),
    UNIQUE KEY uq_subjects_subject_code (subject_code)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS attendance (
    attendance_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    student_id INT UNSIGNED NOT NULL,
    subject_id INT UNSIGNED NOT NULL,
    teacher_id INT UNSIGNED NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('P', 'A', 'L') NOT NULL,
    PRIMARY KEY (attendance_id),
    UNIQUE KEY uq_attendance_student_subject_date
        (student_id, subject_id, attendance_date),
    KEY idx_attendance_date_subject (attendance_date, subject_id),
    CONSTRAINT fk_attendance_student
        FOREIGN KEY (student_id) REFERENCES students (student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_attendance_subject
        FOREIGN KEY (subject_id) REFERENCES subjects (subject_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_attendance_teacher
        FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Sample records. Explicit IDs and upserts make the sample data safe to
-- insert again after the tables have been created.
INSERT INTO students
    (student_id, student_name, roll_no, class_name, department, phone, email, admission_date)
VALUES
    (1, 'Ananya Sharma', 'CS-101', 'BCA Year 2', 'Computer Science', '9876543210', 'ananya@example.edu', '2024-07-01'),
    (2, 'Rahul Verma',   'CS-102', 'BCA Year 2', 'Computer Science', '9876543211', 'rahul@example.edu',  '2024-07-01'),
    (3, 'Priya Nair',    'CS-103', 'BCA Year 2', 'Computer Science', '9876543212', 'priya@example.edu',  '2024-07-01'),
    (4, 'Karan Singh',   'CS-104', 'BCA Year 2', 'Computer Science', '9876543213', 'karan@example.edu',  '2024-07-01'),
    (5, 'Meera Patel',   'CS-105', 'BCA Year 2', 'Computer Science', '9876543214', 'meera@example.edu',  '2024-07-01')
ON DUPLICATE KEY UPDATE
    student_name = VALUES(student_name),
    class_name = VALUES(class_name),
    department = VALUES(department),
    phone = VALUES(phone),
    email = VALUES(email),
    admission_date = VALUES(admission_date);

INSERT INTO teachers
    (teacher_id, teacher_name, department, phone, email)
VALUES
    (1, 'Rani Gupta', 'Computer Science', '9123456780', 'rani.gupta@example.edu'),
    (2, 'Arjun Kumar', 'Computer Science', '9123456781', 'arjun.kumar@example.edu')
ON DUPLICATE KEY UPDATE
    teacher_name = VALUES(teacher_name),
    department = VALUES(department),
    phone = VALUES(phone),
    email = VALUES(email);

INSERT INTO subjects
    (subject_id, subject_name, subject_code)
VALUES
    (1, 'Database Management Systems', 'DBMS101'),
    (2, 'Java Programming', 'JAVA201'),
    (3, 'Operating Systems', 'OS301')
ON DUPLICATE KEY UPDATE
    subject_name = VALUES(subject_name),
    subject_code = VALUES(subject_code);

INSERT INTO attendance
    (attendance_id, student_id, subject_id, teacher_id, attendance_date, status)
VALUES
    (1,  1, 1, 1, '2026-10-01', 'P'),
    (2,  2, 1, 1, '2026-10-01', 'A'),
    (3,  3, 1, 1, '2026-10-01', 'P'),
    (4,  4, 1, 1, '2026-10-01', 'L'),
    (5,  5, 1, 1, '2026-10-01', 'P'),
    (6,  1, 2, 2, '2026-10-02', 'P'),
    (7,  2, 2, 2, '2026-10-02', 'P'),
    (8,  3, 2, 2, '2026-10-02', 'A'),
    (9,  4, 2, 2, '2026-10-02', 'P'),
    (10, 5, 2, 2, '2026-10-02', 'P'),
    (11, 1, 3, 1, '2026-10-03', 'A'),
    (12, 2, 3, 1, '2026-10-03', 'P'),
    (13, 3, 3, 1, '2026-10-03', 'P'),
    (14, 4, 3, 1, '2026-10-03', 'P'),
    (15, 5, 3, 1, '2026-10-03', 'L')
ON DUPLICATE KEY UPDATE
    teacher_id = VALUES(teacher_id),
    status = VALUES(status);

-- ---------------------------------------------------------------------------
-- Demonstration queries
-- Run these separately in Workbench to capture each result grid.
-- ---------------------------------------------------------------------------

-- 1. List all students.
SELECT student_id, student_name, roll_no, class_name, department
FROM students
ORDER BY roll_no;

-- 2. Show attendance with student, subject, and teacher names.
SELECT
    a.attendance_date,
    s.roll_no,
    s.student_name,
    sub.subject_name,
    t.teacher_name,
    CASE a.status
        WHEN 'P' THEN 'Present'
        WHEN 'A' THEN 'Absent'
        WHEN 'L' THEN 'Late'
    END AS attendance_status
FROM attendance AS a
JOIN students AS s ON s.student_id = a.student_id
JOIN subjects AS sub ON sub.subject_id = a.subject_id
JOIN teachers AS t ON t.teacher_id = a.teacher_id
ORDER BY a.attendance_date, sub.subject_name, s.roll_no;

-- 3. Attendance percentage per student and subject.
-- Rule for this project: Present and Late count as attended.
SELECT
    s.roll_no,
    s.student_name,
    sub.subject_name,
    COUNT(a.attendance_id) AS sessions_held,
    SUM(CASE WHEN a.status IN ('P', 'L') THEN 1 ELSE 0 END) AS sessions_attended,
    ROUND(
        100.0 * SUM(CASE WHEN a.status IN ('P', 'L') THEN 1 ELSE 0 END)
        / NULLIF(COUNT(a.attendance_id), 0),
        2
    ) AS attendance_percentage
FROM students AS s
CROSS JOIN subjects AS sub
LEFT JOIN attendance AS a
    ON a.student_id = s.student_id
   AND a.subject_id = sub.subject_id
GROUP BY s.student_id, s.roll_no, s.student_name, sub.subject_id, sub.subject_name
ORDER BY s.roll_no, sub.subject_name;

-- 4. Attendance count by subject and status.
SELECT
    sub.subject_name,
    SUM(CASE WHEN a.status = 'P' THEN 1 ELSE 0 END) AS present_count,
    SUM(CASE WHEN a.status = 'A' THEN 1 ELSE 0 END) AS absent_count,
    SUM(CASE WHEN a.status = 'L' THEN 1 ELSE 0 END) AS late_count,
    COUNT(*) AS total_records
FROM attendance AS a
JOIN subjects AS sub ON sub.subject_id = a.subject_id
GROUP BY sub.subject_id, sub.subject_name
ORDER BY sub.subject_name;

-- 5. Daily summary.
SELECT
    attendance_date,
    SUM(CASE WHEN status = 'P' THEN 1 ELSE 0 END) AS present_count,
    SUM(CASE WHEN status = 'A' THEN 1 ELSE 0 END) AS absent_count,
    SUM(CASE WHEN status = 'L' THEN 1 ELSE 0 END) AS late_count,
    COUNT(*) AS total_records
FROM attendance
GROUP BY attendance_date
ORDER BY attendance_date;

-- 6. Find absences for a selected date.
SELECT
    a.attendance_date,
    s.roll_no,
    s.student_name,
    sub.subject_name
FROM attendance AS a
JOIN students AS s ON s.student_id = a.student_id
JOIN subjects AS sub ON sub.subject_id = a.subject_id
WHERE a.status = 'A'
  AND a.attendance_date = '2026-10-01'
ORDER BY s.roll_no;

-- 7. Add a new attendance record (change IDs/date as required).
-- The unique key prevents marking the same student, subject, and date twice.
-- INSERT INTO attendance (student_id, subject_id, teacher_id, attendance_date, status)
-- VALUES (1, 1, 1, '2026-10-04', 'P');

-- 8. Correct an existing record.
-- UPDATE attendance
-- SET status = 'P'
-- WHERE student_id = 2
--   AND subject_id = 1
--   AND attendance_date = '2026-10-01';
