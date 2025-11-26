# Blueprint: School Management System (Flutter)

## 1. Project Overview

This document outlines the plan for building a comprehensive, offline-first School Management System using Flutter and a local SQLite database. The application is designed with a modern, professional, and responsive user interface, following a clean and scalable architecture.

## 2. Core Features

The application includes the following features:

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
    *   View detailed teacher profiles with photos.
    *   Assign teachers to classes.
*   **Class & Schedule Management:**
    *   Create and manage classes and sections.
    *   Define class schedules.
*   **Attendance Tracking:**
    *   Record daily attendance for students.
    *   Record attendance for teachers.
    *   Generate attendance reports.
*   **Exams & Results (Grades):**
    *   Create and manage student grades.
    *   Input student grades for each subject.
    *   View and manage grades by student.
*   **Fees Management:**
    *   Track student fee payments.
    *   Filter students by fee status (paid/unpaid).
*   **Database Management:**
    *   Export the SQLite database to a backup file.
    *   Import data from a backup file.

## 3. Architecture

We use a layered architecture to ensure a clean separation of concerns:

*   **UI (Presentation Layer):** Contains all the Flutter widgets, screens, and UI-related logic.
*   **Business Logic Layer (BLL):** Manages the application's state and business rules. We use `provider` for state management.
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
│   │   │   ├── fee.dart
│   │   │   ├── attendance.dart
│   │   │   └── grade.dart
│   │   ├── repositories
│   │   │   ├── student_repository.dart
│   │   │   ├── teacher_repository.dart
│   │   │   ├── fee_repository.dart
│   │   │   ├── attendance_repository.dart
│   │   │   └── grade_repository.dart
│   │   ├── utils
│   │   │   ├── theme_provider.dart
│   │   │   └── ...
│   │   └── views
│   │       ├── dashboard
│   │       │   └── dashboard_screen.dart
│   │       ├── home
│   │       │   └── home_screen.dart
│   │       ├── students
│   │       │   ├── add_edit_student_screen.dart
│   │       │   ├── student_details_screen.dart
│   │       │   └── student_list_screen.dart
│   │       ├── teachers
│   │       │   ├── add_edit_teacher_screen.dart
│   │       │   ├── teacher_details_screen.dart
│   │       │   └── teacher_list_screen.dart
│   │       ├── fees
│   │       │   ├── add_edit_fee_screen.dart
│   │       │   └── fee_list_screen.dart
│   │       ├── attendance
│   │       │   ├── add_edit_attendance_screen.dart
│   │       │   └── attendance_list_screen.dart
│   │       └── grades
│   │           ├── add_edit_grade_screen.dart
│   │           └── grade_list_screen.dart
│   └── ...
├── pubspec.yaml
└── ...
```

## 5. Enhancements and Improvements

This version of the application includes the following enhancements:

*   **Responsive Design:**
    *   The dashboard now uses a `GridView` that adapts to different screen sizes.
    *   The main navigation uses a permanent drawer on wider screens for a better user experience on desktops and tablets.
*   **Detailed Views:**
    *   Student and teacher lists now navigate to dedicated detail screens, showing more information about each person.
    *   An "Edit" button has been added to the detail screens for quick access to the editing functionality.
*   **Improved User Experience:**
    *   The `add_edit_fee_screen.dart` and `add_edit_grade_screen.dart` now use dropdown menus to select students, reducing the chances of data entry errors.
    *   Search functionality has been added to the student and teacher list screens, making it easier to find specific records.

## 6. Current Plan

*   **Task:** Continue to refine and improve the application based on user feedback.
*   **Description:** The application is now in a stable state with all the core features implemented. The next steps will involve further testing, bug fixing, and the addition of new features as requested by the users. The focus will be on improving the overall user experience and performance of the application.
