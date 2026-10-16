# Student Attendance Management System

A database mini-project implemented with MySQL. It records students, teachers, subjects, and daily attendance, and provides queries for attendance listings, percentages, and summaries.

## Project files

| File | Purpose |
| --- | --- |
| `student_attendance.sql` | Creates the database and tables, loads sample data, and contains demonstration queries |
| `MYSQL_WORKBENCH_GUIDE.md` | Instructions for running the SQL in Workbench and taking project screenshots |
| `report.tex` | Editable LaTeX report source |

## Quick start

1. Install and start MySQL Server 8.0+ and MySQL Workbench.
2. Open `student_attendance.sql` in Workbench.
3. Execute the whole script once to create `student_attendance_db` and load the example records.
4. Execute the individual report queries near the end of the script and inspect the Result Grid.
5. Follow `MYSQL_WORKBENCH_GUIDE.md` to capture your screenshots.
6. Edit and compile `report.tex` after replacing all personal and college placeholders.

## Data model

- **students**: student identity and class details
- **teachers**: teacher identity and department details
- **subjects**: subject names and unique codes
- **attendance**: one student's status for one subject on one date, linked to a teacher

The attendance table uses foreign keys and prevents duplicate attendance for the same student, subject, and date. Status values are `P` (Present), `A` (Absent), and `L` (Late). In the percentage query, Late is counted as attended; change the formula in the SQL and report if your institution uses a different rule.

## Notes

- This is a database-focused mini-project and does not implement a login or graphical application.
- The sample data is fictitious. Replace it with approved data if required, and do not include real personal data in publicly shared screenshots.
- Check your college's prescribed format and obtain required approval/signatures for report sections such as the certificate.
