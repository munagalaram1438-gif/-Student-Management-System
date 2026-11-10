# Student Management System — Professional Edition

A student-focused academic administration application built with Java 21, Spring Boot, Thymeleaf and MySQL.

## Modules included
- Dashboard and student statistics
- Students: registration, profiles, search, edit and delete
- Departments
- Courses / programmes
- Teachers (academic staff supporting student courses)
- Subjects
- Attendance
- Examinations
- Marks and results
- Student fees
- Announcements for students

All modules are scoped to student records and academic administration. This is not a general-purpose university ERP.

## Requirements
- JDK 21
- MySQL Server 8
- Maven 3.9+

## Database isolation
The app uses its own database `sms_student_db` and tables prefixed `sms_`. It does not alter the older `student_management_system` database.

## Run on Windows PowerShell
Extract the ZIP and open PowerShell in the `Student_Management_System` folder. Run these commands in the same terminal:

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/sms_student_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata"
$env:DB_USERNAME="root"
$env:DB_PASSWORD = Read-Host "Enter your MySQL root password"
& "$HOME\Downloads\apache-maven-3.10.0-bin\apache-maven-3.10.0\bin\mvn.cmd" clean spring-boot:run
```

Port is **8081** to avoid the old app on 8080.

- Dashboard: http://localhost:8081/
- Students: http://localhost:8081/manage/students
- Add student: http://localhost:8081/manage/students/new
- Departments: http://localhost:8081/manage/departments
- Courses: http://localhost:8081/manage/courses

The login page is a welcome/entry screen only. Real authentication has not been implemented; add Spring Security before production use.
