CREATE DATABASE IF NOT EXISTS student_management_system
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_management_system;

CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN','TEACHER','STUDENT')),
  enabled BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE departments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL UNIQUE,
  description VARCHAR(500)
) ENGINE=InnoDB;

CREATE TABLE courses (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  duration_years INT NOT NULL,
  department_id BIGINT NOT NULL,
  CONSTRAINT fk_course_department FOREIGN KEY (department_id) REFERENCES departments(id)
) ENGINE=InnoDB;

CREATE TABLE students (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_number VARCHAR(30) NOT NULL UNIQUE,
  full_name VARCHAR(140) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  phone VARCHAR(20),
  date_of_birth DATE,
  gender VARCHAR(20),
  address VARCHAR(500),
  department_id BIGINT,
  course_id BIGINT,
  academic_year INT,
  admission_date DATE,
  photo_path VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_student_department FOREIGN KEY (department_id) REFERENCES departments(id),
  CONSTRAINT fk_student_course FOREIGN KEY (course_id) REFERENCES courses(id)
) ENGINE=InnoDB;

CREATE TABLE teachers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  employee_number VARCHAR(30) NOT NULL UNIQUE,
  full_name VARCHAR(140) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  phone VARCHAR(20),
  designation VARCHAR(120),
  joining_date DATE,
  department_id BIGINT,
  CONSTRAINT fk_teacher_department FOREIGN KEY (department_id) REFERENCES departments(id)
) ENGINE=InnoDB;

CREATE TABLE subjects (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  code VARCHAR(30) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  course_id BIGINT NOT NULL,
  semester INT NOT NULL,
  credits DECIMAL(4,1) NOT NULL DEFAULT 0,
  CONSTRAINT fk_subject_course FOREIGN KEY (course_id) REFERENCES courses(id)
) ENGINE=InnoDB;

CREATE TABLE teacher_courses (
  teacher_id BIGINT NOT NULL,
  course_id BIGINT NOT NULL,
  PRIMARY KEY (teacher_id, course_id),
  FOREIGN KEY (teacher_id) REFERENCES teachers(id),
  FOREIGN KEY (course_id) REFERENCES courses(id)
) ENGINE=InnoDB;

CREATE TABLE attendance (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_id BIGINT NOT NULL,
  subject_id BIGINT NOT NULL,
  attendance_date DATE NOT NULL,
  status ENUM('PRESENT','ABSENT','LATE','EXCUSED') NOT NULL,
  marked_by BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_attendance_student_subject_date (student_id, subject_id, attendance_date),
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (subject_id) REFERENCES subjects(id),
  FOREIGN KEY (marked_by) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE examinations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  exam_type VARCHAR(40) NOT NULL,
  subject_id BIGINT NOT NULL,
  exam_date DATE,
  max_marks DECIMAL(7,2) NOT NULL,
  academic_year INT,
  FOREIGN KEY (subject_id) REFERENCES subjects(id)
) ENGINE=InnoDB;

CREATE TABLE marks (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  examination_id BIGINT NOT NULL,
  student_id BIGINT NOT NULL,
  marks_obtained DECIMAL(7,2) NOT NULL,
  grade VARCHAR(5),
  remarks VARCHAR(255),
  UNIQUE KEY uq_marks_exam_student (examination_id, student_id),
  FOREIGN KEY (examination_id) REFERENCES examinations(id),
  FOREIGN KEY (student_id) REFERENCES students(id)
) ENGINE=InnoDB;

CREATE TABLE fees (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  course_id BIGINT NOT NULL,
  academic_year INT NOT NULL,
  fee_type VARCHAR(80) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  due_date DATE,
  FOREIGN KEY (course_id) REFERENCES courses(id)
) ENGINE=InnoDB;

CREATE TABLE payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  student_id BIGINT NOT NULL,
  fee_id BIGINT NOT NULL,
  amount_paid DECIMAL(12,2) NOT NULL,
  payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  payment_method VARCHAR(40),
  transaction_reference VARCHAR(100),
  receipt_number VARCHAR(50) NOT NULL UNIQUE,
  recorded_by BIGINT,
  FOREIGN KEY (student_id) REFERENCES students(id),
  FOREIGN KEY (fee_id) REFERENCES fees(id),
  FOREIGN KEY (recorded_by) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE announcements (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(180) NOT NULL,
  body TEXT NOT NULL,
  audience ENUM('ALL','ADMIN','TEACHER','STUDENT') NOT NULL DEFAULT 'ALL',
  published_at DATETIME,
  expires_at DATETIME,
  created_by BIGINT,
  FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE activity_logs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT,
  action VARCHAR(120) NOT NULL,
  entity_type VARCHAR(80),
  entity_id BIGINT,
  details VARCHAR(1000),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE INDEX idx_students_name ON students(full_name);
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_payments_student ON payments(student_id);
