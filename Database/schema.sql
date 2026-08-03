-- ============================================================
-- MySQL Database Setup Script for API Workflow Project
-- Architecture: Flutter -> Internet -> ASP.NET Core API -> MySQL
-- Author: Prit Dhanani
-- ============================================================

-- Create Database if not exists
CREATE DATABASE IF NOT EXISTS api_workflow_db;
USE api_workflow_db;

-- Drop table if exists for clean setup
DROP TABLE IF EXISTS students;

-- Create Students Table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    course VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
