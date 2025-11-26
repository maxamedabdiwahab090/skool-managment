# Blueprint: School Management System (Flutter)

## 1. Project Overview

This document outlines the plan for building a comprehensive, offline-first School Management System using Flutter and a local SQLite database. The application will be designed with a modern, professional, and responsive user interface, following a clean and scalable architecture.

## 2. Core Features

The application will include the following features:

*   **Authentication:**
    *   Secure Admin login.
*   **Dashboard:**
    *   Overview widgets for key statistics (e.g., total students, teachers, attendance percentage).
    *   Quick navigation to major modules.
*   **Student Management:**
    *   Add, edit, and delete student records.
    *   View detailed student profiles with photos.
    *   Assign students to classes and sections.
*   **Teacher Management:**
    *   Add, edit, and delete teacher records.
    *   Assign teachers to classes.
*   **Class & Schedule Management:**
    *   Create and manage classes and sections.
    *   Define class schedules.
*   **Attendance Tracking:**
    *   Record daily attendance for students.
    *   Record attendance for teachers.
    *   Generate attendance reports.
*   **Exams & Results:**
    *   Create exam records.
    *   Input student marks for each exam.
    *   View and manage results by student or class.
*   **Fees Management:**
    *   Track student fee payments.
    *   Filter students by fee status (paid/unpaid).
*   **Database Management:**
    *   Export the SQLite database to a backup file.
    *   Import data from a backup file.

## 3. Architecture

We will use a layered architecture to ensure a clean separation of concerns:

*   **UI (Presentation Layer):** Contains all the Flutter widgets, screens, and UI-related logic.
*   **Business Logic Layer (BLL):** Manages the application's state and business rules. We will use `provider` for state management.
*   **Data Access Layer (DAL):** Responsible for all interactions with the SQLite database.

## 4. Project Structure

```
.
├── lib
│   ├── main.dart
│   ├── src
│   │   ├── api
│   │   │   └── db_provider.dart
│   │   ├── models
│   │   │   ├── student.dart
│   │   │   ├── teacher.dart
│   │   │   └── ...
│   │   ├── repositories
│   │   │   ├── student_repository.dart
│   │   │   ├── teacher_repository.dart
│   │   │   └── ...
│   │   ├── utils
│   │   │   ├── theme_provider.dart
│   │   │   └── ...
│   │   └── views
│   │       ├── dashboard
│   │       │   └── dashboard_screen.dart
│   │       ├── home
│   │       │   └── home_screen.dart
│   │       ├── student
│   │       │   ├── add_edit_student_screen.dart
│   │       │   ├── student_details_screen.dart
│   │       │   ├── student_list_screen.dart
│   │       │   └── ...
│   │       ├── teacher
│   │       │   ├── add_edit_teacher_screen.dart
│   │       │   ├── teacher_list_screen.dart
│   │       │   └── ...
│   │       └── ...
│   └── ...
├── pubspec.yaml
└── ...
```

## 5. Current Plan

*   **Task:** Implement the Teacher Management feature.
*   **Description:** The `Teacher` model, `TeacherRepository`, and the necessary screens for adding, editing, and listing teachers have been created. The navigation has been updated to include a "Teachers" section.
