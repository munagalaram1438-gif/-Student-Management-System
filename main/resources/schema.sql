CREATE TABLE IF NOT EXISTS sms_students (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, registration_number VARCHAR(40) NOT NULL UNIQUE,
 full_name VARCHAR(120) NOT NULL, email VARCHAR(150) NOT NULL UNIQUE, phone VARCHAR(25),
 department VARCHAR(100), programme VARCHAR(100), year_of_study VARCHAR(30), status VARCHAR(20) NOT NULL DEFAULT 'Active',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS sms_departments (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, department_code VARCHAR(30) NOT NULL UNIQUE,
 department_name VARCHAR(120) NOT NULL, description VARCHAR(255), head_of_department VARCHAR(120)
);
CREATE TABLE IF NOT EXISTS sms_courses (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, course_code VARCHAR(30) NOT NULL UNIQUE,
 course_name VARCHAR(120) NOT NULL, department VARCHAR(100), duration VARCHAR(40), programme_level VARCHAR(40)
);
CREATE TABLE IF NOT EXISTS sms_teachers (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, employee_id VARCHAR(40) NOT NULL UNIQUE,
 full_name VARCHAR(120) NOT NULL, email VARCHAR(150) NOT NULL, department VARCHAR(100), specialization VARCHAR(120), phone VARCHAR(25)
);
CREATE TABLE IF NOT EXISTS sms_subjects (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, subject_code VARCHAR(30) NOT NULL UNIQUE,
 subject_name VARCHAR(120) NOT NULL, course VARCHAR(120), semester VARCHAR(30), credits INT
);
CREATE TABLE IF NOT EXISTS sms_attendance (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, registration_number VARCHAR(40) NOT NULL,
 subject_code VARCHAR(30), attendance_date DATE NOT NULL, attendance_status VARCHAR(20) NOT NULL, remarks VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS sms_examinations (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, exam_name VARCHAR(120) NOT NULL, course VARCHAR(120),
 subject_code VARCHAR(30), exam_date DATE, maximum_marks INT
);
CREATE TABLE IF NOT EXISTS sms_marks (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, registration_number VARCHAR(40) NOT NULL,
 subject_code VARCHAR(30) NOT NULL, exam_name VARCHAR(120), marks_obtained DECIMAL(8,2) NOT NULL,
 maximum_marks DECIMAL(8,2) NOT NULL, grade VARCHAR(10)
);
CREATE TABLE IF NOT EXISTS sms_fees (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, registration_number VARCHAR(40) NOT NULL,
 fee_type VARCHAR(100) NOT NULL, amount DECIMAL(10,2) NOT NULL, due_date DATE, payment_status VARCHAR(30) NOT NULL
);
CREATE TABLE IF NOT EXISTS sms_announcements (
 id BIGINT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(150) NOT NULL, message TEXT NOT NULL,
 audience VARCHAR(100), publish_date DATE
);
