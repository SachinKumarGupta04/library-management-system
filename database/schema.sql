-- Library Management System Database Schema

CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- Users Table (Librarians and Students)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    role ENUM('LIBRARIAN', 'STUDENT') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Books Table
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    category VARCHAR(50),
    publication_year INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    shelf_location VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_isbn (isbn)
);

-- Book Issuance Table
CREATE TABLE issuances (
    issuance_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    issued_by INT NOT NULL,
    status ENUM('ISSUED', 'RETURNED', 'OVERDUE') DEFAULT 'ISSUED',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (issued_by) REFERENCES users(user_id),
    INDEX idx_status (status),
    INDEX idx_user (user_id),
    INDEX idx_dates (issue_date, due_date)
);

-- Fines Table
CREATE TABLE fines (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    issuance_id INT NOT NULL,
    user_id INT NOT NULL,
    fine_amount DECIMAL(10, 2) NOT NULL,
    days_overdue INT NOT NULL,
    fine_reason VARCHAR(200),
    payment_status ENUM('PENDING', 'PAID') DEFAULT 'PENDING',
    paid_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (issuance_id) REFERENCES issuances(issuance_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_status (payment_status),
    INDEX idx_user (user_id)
);

-- Notifications Table
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('DUE_DATE', 'OVERDUE', 'FINE', 'GENERAL') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_read (user_id, is_read)
);

-- Insert Default Users
INSERT INTO users (username, password, full_name, email, role) VALUES
('admin', 'admin123', 'Library Admin', 'admin@library.com', 'LIBRARIAN'),
('student1', 'student123', 'John Doe', 'john@student.com', 'STUDENT');

-- Insert Sample Books
INSERT INTO books (isbn, title, author, publisher, category, publication_year, total_copies, available_copies, shelf_location) VALUES
('978-0-13-468599-1', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 'Programming', 2008, 5, 5, 'A-101'),
('978-0-13-235088-4', 'Clean Architecture', 'Robert C. Martin', 'Prentice Hall', 'Software Engineering', 2017, 3, 3, 'A-102'),
('978-0-201-63361-0', 'Design Patterns', 'Gang of Four', 'Addison-Wesley', 'Programming', 1994, 4, 4, 'A-103'),
('978-0-596-52068-7', 'Head First Java', 'Kathy Sierra', 'O''Reilly', 'Java', 2005, 6, 6, 'B-201'),
('978-0-134-68599-2', 'Effective Java', 'Joshua Bloch', 'Addison-Wesley', 'Java', 2018, 5, 5, 'B-202');

-- Stored Procedure to Calculate Fine
DELIMITER //
CREATE PROCEDURE CalculateFine(IN p_issuance_id INT)
BEGIN
    DECLARE v_due_date DATE;
    DECLARE v_return_date DATE;
    DECLARE v_days_overdue INT;
    DECLARE v_fine_amount DECIMAL(10,2);
    DECLARE v_user_id INT;
    
    SELECT due_date, return_date, user_id INTO v_due_date, v_return_date, v_user_id
    FROM issuances WHERE issuance_id = p_issuance_id;
    
    IF v_return_date > v_due_date THEN
        SET v_days_overdue = DATEDIFF(v_return_date, v_due_date);
        SET v_fine_amount = v_days_overdue * 5.00;
        
        INSERT INTO fines (issuance_id, user_id, fine_amount, days_overdue, fine_reason)
        VALUES (p_issuance_id, v_user_id, v_fine_amount, v_days_overdue, 
                CONCAT('Book returned ', v_days_overdue, ' days late'));
    END IF;
END //
DELIMITER ;

-- Trigger to Update Book Availability on Issuance
DELIMITER //
CREATE TRIGGER after_book_issue
AFTER INSERT ON issuances
FOR EACH ROW
BEGIN
    UPDATE books SET available_copies = available_copies - 1 WHERE book_id = NEW.book_id;
END //
DELIMITER ;

-- Trigger to Update Book Availability on Return
DELIMITER //
CREATE TRIGGER after_book_return
AFTER UPDATE ON issuances
FOR EACH ROW
BEGIN
    IF NEW.status = 'RETURNED' AND OLD.status != 'RETURNED' THEN
        UPDATE books SET available_copies = available_copies + 1 WHERE book_id = NEW.book_id;
        CALL CalculateFine(NEW.issuance_id);
    END IF;
END //
DELIMITER ;
