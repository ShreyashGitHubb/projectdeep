# MySQL Workbench Guide

## Student Attendance Management System

This guide explains how to set up the sample database, run the report queries, and collect screenshots for the project report.

## Requirements

- MySQL Server 8.0 or newer
- MySQL Workbench
- The file `student_attendance.sql` from this project folder

The database is a SQL mini-project: it stores student, teacher, subject, and attendance information in MySQL. It does not include a web or desktop user interface.

## 1. Open the MySQL connection

1. Start MySQL Workbench.
2. Open your local MySQL connection (for example, **Local instance MySQL**).
3. Enter your MySQL password if prompted.
4. Create a new SQL tab using **File > New Query Tab**.

## 2. Run the setup script

1. Open `student_attendance.sql` in Workbench with **File > Open SQL Script**, or paste its contents into a new query tab.
2. Click the lightning-bolt **Execute** button to run the full script.
3. If Workbench asks you to select a default schema, the script already selects `student_attendance_db`.
4. In the **Schemas** panel, click **Refresh**. Expand `student_attendance_db` and then **Tables**.
5. Confirm that these tables exist: `students`, `teachers`, `subjects`, and `attendance`.

The sample data uses October 1-3, 2026. The setup script can be run again: sample records are inserted or updated rather than duplicated.

## 3. Run report queries one at a time

For a clean screenshot, select only one query (including its final semicolon) and click the lightning-bolt button. The result appears in the **Result Grid** under the SQL editor.

Recommended queries from the bottom half of `student_attendance.sql`:

1. Student list
2. Attendance joined with student, subject, and teacher names
3. Attendance percentage per student and subject
4. Attendance count by subject and status
5. Daily attendance summary
6. Absences for a selected date

To avoid re-running the whole setup each time, run only the selected `SELECT` statement after initial setup.

## 4. Verify the sample outputs

The sample dataset has 15 attendance records: five students for each of three subjects.

- DBMS: 3 Present, 1 Absent, 1 Late
- Java Programming: 4 Present, 1 Absent, 0 Late
- Operating Systems: 3 Present, 1 Absent, 1 Late

Attendance percentage is calculated per student and subject. In this project, **Late counts as attended**; therefore the numerator includes both `P` and `L`, while the denominator includes all marked sessions.

## 5. Capture and save screenshots

Capture screenshots of your own Workbench results; do not use the example output as if it were a Workbench screenshot.

Suggested screenshots:

| Filename | What to show |
| --- | --- |
| `01-database-and-tables.png` | Schemas panel expanded to show the database and four tables |
| `02-student-list.png` | Student-list query and its Result Grid |
| `03-attendance-details.png` | Joined attendance query and its Result Grid |
| `04-attendance-percentage.png` | Percentage query and its Result Grid |
| `05-subject-summary.png` | Per-subject status counts |
| `06-daily-summary.png` | Daily attendance summary |

Save these images in a folder named `screenshots` beside `report.tex`. Capture the SQL statement and the output clearly, without including passwords or unrelated personal information.

## 6. Useful Workbench operations

### View a table

```sql
USE student_attendance_db;
SELECT * FROM students;
```

You can also right-click a table in the **Schemas** panel and choose **Select Rows - Limit 1000**.

### Add a student

```sql
INSERT INTO students
    (student_name, roll_no, class_name, department, phone, email, admission_date)
VALUES
    ('Sample Student', 'CS-106', 'BCA Year 2', 'Computer Science',
     '9876500000', 'sample.student@example.edu', '2026-07-01');
```

Use a new roll number and email because both fields are unique.

### Mark attendance

```sql
INSERT INTO attendance
    (student_id, subject_id, teacher_id, attendance_date, status)
VALUES
    (1, 1, 1, '2026-10-04', 'P');
```

Valid status codes are `P` (Present), `A` (Absent), and `L` (Late). A student can have only one attendance row for a particular subject and date. If the row already exists, use an `UPDATE` rather than inserting a duplicate.

## 7. Compile the LaTeX report

The report source is `report.tex`.

- **Overleaf:** Create a new project, upload `report.tex` and `student_attendance.sql`, then upload any screenshots into a folder called `screenshots`.
- **Local LaTeX:** Place these files in the same directory and compile with `pdflatex report.tex` (run it twice to populate the table of contents).

The report includes placeholders when optional screenshots have not yet been added. The student name, institution, and submission date are set to Shreyas Vishwakarma, Deep, and October 2026; verify these details, then replace the roll number, course, department, and guide placeholders before submission. Follow your institution's rules for the certificate and acknowledgement.

## Troubleshooting

- **Access denied:** Check the MySQL username/password and ensure the MySQL Server is running.
- **Unknown database:** Execute the setup section at the top of `student_attendance.sql`.
- **Duplicate key:** The sample inserts are designed to be rerunnable. For manual inserts, choose a unique roll number, email, subject code, and student/subject/date combination.
- **Foreign key error:** Ensure the referenced student, teacher, and subject rows exist before inserting attendance.
- **Schema not visible:** Refresh the Schemas panel in Workbench.
