-- ============================================================
-- Sample Data Inserts for API Workflow Project
-- Database: api_workflow_db
-- ============================================================

USE api_workflow_db;

-- Seed Sample Students
INSERT INTO students (name, email, course) VALUES
('Prit Dhanani', 'prit@gmail.com', 'Flutter & .NET Development'),
('Alex Johnson', 'alex.j@example.com', 'Mobile Application Architecture'),
('Sophia Chen', 'sophia.c@example.com', 'Cloud & Database Design');

-- Verify Data
SELECT * FROM students;
