# Student Management System — module upgrade

This upgrade adds a database-backed management area for the tables already defined in `database/schema.sql`.

## Modules
Students, teachers, departments, courses, subjects, attendance, examinations, marks/results, fee structures, payments and announcements.

## Run
1. Keep MySQL Server running.
2. Ensure `student_management_system` exists and import `database/schema.sql` if its tables are not already present.
3. Set the MySQL password in the same PowerShell terminal before starting:
   `$env:DB_PASSWORD = 'YOUR_MYSQL_PASSWORD'`
4. From this project folder run:
   `mvn spring-boot:run`
5. Open `http://localhost:8080` and sign in with the admin account created by the bootstrap configuration.
6. Use **All modules** in the sidebar or `/manage`.

## Notes and current limitations
- Module pages use a strict server-side allowlist of table and column names; user-entered values are passed as SQL parameters.
- Foreign-key fields are currently entered as existing numeric record IDs. Add the referenced department/course/student/subject first.
- Database uniqueness and foreign-key constraints are enforced by MySQL. Deleting a record referenced by another record is rejected and reported.
- This is an administrative CRUD foundation, not a production deployment. It does not yet include file uploads, bulk import, PDF receipts, automated fee allocation, attendance percentage reports, or granular teacher/student self-service permissions. Those require separate workflows and testing.
