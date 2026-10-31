-- ========================================================
-- Campus Club Management System - MySQL Database Script
-- ========================================================

CREATE DATABASE IF NOT EXISTS campus_club_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campus_club_db;

-- 1. Users Table (Handles Admin, Student, Coordinator roles)
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'STUDENT', 'COORDINATOR') NOT NULL,
    student_id VARCHAR(50) NULL,
    department VARCHAR(100) NULL,
    phone VARCHAR(30) NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Clubs Table
CREATE TABLE IF NOT EXISTS clubs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    coordinator_id BIGINT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_club_coordinator FOREIGN KEY (coordinator_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 3. Club Memberships Table
CREATE TABLE IF NOT EXISTS club_members (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    club_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_member_club FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    CONSTRAINT fk_member_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_club_user (club_id, user_id)
);

-- 4. Events Table
CREATE TABLE IF NOT EXISTS events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_date DATETIME NOT NULL,
    venue VARCHAR(150) NOT NULL,
    max_participants INT DEFAULT 100,
    club_id BIGINT NOT NULL,
    status ENUM('UPCOMING', 'COMPLETED', 'CANCELLED') DEFAULT 'UPCOMING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_club FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE
);

-- 5. Event Registrations Table
CREATE TABLE IF NOT EXISTS event_registrations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attendance_status ENUM('REGISTERED', 'ATTENDED', 'ABSENT', 'CANCELLED') DEFAULT 'REGISTERED',
    CONSTRAINT fk_reg_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    CONSTRAINT fk_reg_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_event_user (event_id, user_id)
);

-- 6. Announcements Table
CREATE TABLE IF NOT EXISTS announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    scope ENUM('CAMPUS', 'CLUB') DEFAULT 'CAMPUS',
    club_id BIGINT NULL,
    posted_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_announcement_club FOREIGN KEY (club_id) REFERENCES clubs(id) ON DELETE CASCADE,
    CONSTRAINT fk_announcement_poster FOREIGN KEY (posted_by) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. Activity Logs Table
CREATE TABLE IF NOT EXISTS activity_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(255) NOT NULL,
    details TEXT,
    user_id BIGINT NULL,
    club_id BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- Seed Initial Sample Data
-- ========================================================

-- Insert Initial Users (Admin, Coordinators, Students)
INSERT INTO users (id, name, email, password, role, student_id, department, phone, status) VALUES
(1, 'Admin', 'admin@campus.edu', 'admin123', 'ADMIN', 'ADM001', 'Administration', '+91 9876500000', 'ACTIVE'),
(2, 'Club Coordinator', 'coordinator@campus.edu', 'coord123', 'COORDINATOR', 'FAC001', 'Computer Science', '+91 9876500001', 'ACTIVE'),
(3, 'Maya Lin', 'maya.lin@campus.edu', 'coord123', 'COORDINATOR', 'FAC002', 'Fine Arts', '+91 9876500002', 'ACTIVE'),
(4, 'Carlos Gomez', 'carlos.gomez@campus.edu', 'coord123', 'COORDINATOR', 'FAC003', 'Sports & Athletics', '+91 9876500003', 'ACTIVE'),
(5, 'Sarah Jenkins', 'sarah.jenkins@campus.edu', 'coord123', 'COORDINATOR', 'FAC004', 'Environmental Science', '+91 9876500004', 'ACTIVE'),
(6, 'David Thorne', 'david.thorne@campus.edu', 'coord123', 'COORDINATOR', 'FAC005', 'Literature & Humanities', '+91 9876500005', 'ACTIVE'),
(7, 'Mokshagna', 'mokshagna@student.campus.edu', 'student123', 'STUDENT', '23CS010', 'CSE', '+91 9876543210', 'ACTIVE'),
(8, 'Aarav Sharma', 'aarav.sharma@student.campus.edu', 'student123', 'STUDENT', '23CS001', 'CSE', '+91 9876543211', 'ACTIVE'),
(9, 'Diya Patel', 'diya.patel@student.campus.edu', 'student123', 'STUDENT', '23EC014', 'ECE', '+91 9876543212', 'ACTIVE'),
(10, 'Rohan Kumar', 'rohan.kumar@student.campus.edu', 'student123', 'STUDENT', '23ME022', 'Mechanical', '+91 9876543213', 'ACTIVE'),
(11, 'Sneha Iyer', 'sneha.iyer@student.campus.edu', 'student123', 'STUDENT', '23IT037', 'IT', '+91 9876543214', 'ACTIVE'),
(12, 'Vikram Singh', 'vikram.singh@student.campus.edu', 'student123', 'STUDENT', '23EE045', 'EEE', '+91 9876543215', 'ACTIVE')
ON DUPLICATE KEY UPDATE id=id;

-- Insert 8 Clubs matching UI
INSERT INTO clubs (id, name, category, description, coordinator_id, status) VALUES
(1, 'Coding Club', 'Technology', 'Explore coding & tech', 2, 'ACTIVE'),
(2, 'Sports Club', 'Sports', 'Sports & fitness', 4, 'ACTIVE'),
(3, 'Cultural Club', 'Arts', 'Arts, culture & creativity', 3, 'ACTIVE'),
(4, 'Environment Club', 'Environment', 'Go green, save Earth', 5, 'ACTIVE'),
(5, 'Literary Club', 'Literature', 'Books, discussion & writing', 6, 'ACTIVE'),
(6, 'Robotics Club', 'Technology', 'Autonomous robotics, IoT sensors, and drone design', NULL, 'ACTIVE'),
(7, 'Music Club', 'Arts', 'Campus orchestra, acoustic sessions and live gigs', NULL, 'ACTIVE'),
(8, 'Photography Club', 'Media', 'Visual storytelling, editing, and campus photojournalism', NULL, 'ACTIVE')
ON DUPLICATE KEY UPDATE id=id;

-- Insert Club Memberships
INSERT INTO club_members (club_id, user_id, status) VALUES
(1, 7, 'APPROVED'), -- Mokshagna in Coding Club
(2, 7, 'APPROVED'), -- Mokshagna in Sports Club
(1, 8, 'APPROVED'), -- Aarav in Coding Club
(1, 9, 'APPROVED'), -- Diya in Coding Club
(1, 10, 'APPROVED'), -- Rohan in Coding Club
(1, 11, 'APPROVED'), -- Sneha in Coding Club
(1, 12, 'APPROVED'), -- Vikram in Coding Club
(2, 8, 'APPROVED'), -- Aarav in Sports Club
(2, 10, 'APPROVED'), -- Rohan in Sports Club
(3, 9, 'APPROVED'), -- Diya in Cultural Club
(3, 11, 'APPROVED'), -- Sneha in Cultural Club
(4, 12, 'APPROVED'), -- Vikram in Environment Club
(5, 7, 'PENDING')   -- Mokshagna pending in Literary Club
ON DUPLICATE KEY UPDATE id=id;

-- Insert Events matching UI
INSERT INTO events (id, title, description, event_date, venue, max_participants, club_id, status) VALUES
(1, 'Tech Talk', 'Explore system architecture, AI tools, and full-stack software development workflows.', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 5 DAY), 'Seminar Hall 1', 100, 1, 'UPCOMING'),
(2, 'Clean Campus Drive', 'A green sustainability initiative to plant trees and maintain a plastic-free campus.', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 2 DAY), 'Central Lawn', 80, 4, 'ONGOING'),
(3, 'Sports Day', 'Annual track and field championships and intra-college athletic matches.', DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 12 DAY), 'Athletics Arena', 150, 2, 'COMPLETED'),
(4, 'Cultural Fest', 'Celebration of student talent in classical arts, drama, literature, and stage shows.', DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 20 DAY), 'Open Air Theater', 200, 5, 'COMPLETED'),
(5, 'Workshop', 'Hands-on interactive training on modern cloud databases, REST APIs, and UI engineering.', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 15 DAY), 'Computer Lab 4', 60, 1, 'UPCOMING'),
(6, 'Sports Meet', 'Inter-college football, basketball and badminton matches.', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 25 DAY), 'Sports Complex', 120, 2, 'UPCOMING')
ON DUPLICATE KEY UPDATE id=id;

-- Insert Event Registrations (Tech Talk registrations matching Screen 9)
INSERT INTO event_registrations (event_id, user_id, attendance_status) VALUES
(1, 8, 'REGISTERED'),  -- Aarav Sharma
(1, 9, 'REGISTERED'),  -- Diya Patel
(1, 10, 'REGISTERED'), -- Rohan Kumar
(1, 11, 'REGISTERED'), -- Sneha Iyer
(1, 12, 'REGISTERED'), -- Vikram Singh
(1, 7, 'REGISTERED'),  -- Mokshagna
(2, 7, 'REGISTERED'),  -- Mokshagna
(5, 7, 'REGISTERED'),  -- Mokshagna
(4, 7, 'REGISTERED'),  -- Mokshagna
(6, 7, 'REGISTERED')   -- Mokshagna
ON DUPLICATE KEY UPDATE id=id;

-- Insert Announcements
INSERT INTO announcements (title, content, scope, club_id, posted_by) VALUES
('Welcome to Campus Club Management System (CCMS)!', 'Connect with peer clubs, participate in college events, and grow your skills. Registration for new semester clubs is open!', 'CAMPUS', NULL, 1),
('Tech Talk Registration Open', 'Join us for an exciting session with industry mentors this week at Seminar Hall 1.', 'CLUB', 1, 2),
('Clean Campus Drive Volunteers Needed', 'Register now to take part in the green tree-plantation campaign.', 'CLUB', 4, 5)
ON DUPLICATE KEY UPDATE id=id;

-- Insert Activity Logs
INSERT INTO activity_logs (action, details, user_id, club_id) VALUES
('SYSTEM_INIT', 'Database initialized with college clubs and students.', 1, NULL),
('CLUB_CREATED', 'Coding Club registered under Computer Science.', 1, 1),
('EVENT_CREATED', 'Tech Talk event published.', 2, 1);

