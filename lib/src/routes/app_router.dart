import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/views/dashboard/dashboard_screen.dart';
import 'package:myapp/src/views/home/home_screen.dart';
import 'package:myapp/src/views/students/add_edit_student_screen.dart';
import 'package:myapp/src/views/students/student_details_screen.dart';
import 'package:myapp/src/views/students/student_list_screen.dart';
import 'package:myapp/src/views/teachers/add_edit_teacher_screen.dart';
import 'package:myapp/src/views/teachers/teacher_details_screen.dart';
import 'package:myapp/src/views/teachers/teacher_list_screen.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/views/fees/fee_list_screen.dart';
import 'package:myapp/src/views/fees/add_edit_fee_screen.dart';
import 'package:myapp/src/models/fee.dart';
// import 'package:myapp/src/views/attendance/attendance_list_screen.dart';
// import 'package:myapp/src/views/attendance/add_edit_attendance_screen.dart';
import 'package:myapp/src/views/grades/grade_list_screen.dart';
import 'package:myapp/src/views/grades/add_edit_grade_screen.dart';
import 'package:myapp/src/models/grade.dart';
import 'package:myapp/src/views/splash_screen.dart';
import 'package:myapp/src/views/auth/login_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/students',
            builder: (context, state) => const StudentListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditStudentScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => AddEditStudentScreen(student: state.extra as Student?),
              ),
              GoRoute(
                path: 'details',
                builder: (context, state) => StudentDetailsScreen(student: state.extra as Student),
              ),
            ],
          ),
          GoRoute(
            path: '/teachers',
            builder: (context, state) => const TeacherListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditTeacherScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => AddEditTeacherScreen(teacher: state.extra as Teacher?),
              ),
              GoRoute(
                path: 'details',
                builder: (context, state) => TeacherDetailsScreen(teacher: state.extra as Teacher),
              ),
            ],
          ),
          GoRoute(
            path: '/fees',
            builder: (context, state) => const FeeListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditFeeScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => AddEditFeeScreen(fee: state.extra as Fee?),
              ),
            ],
          ),
          // GoRoute(
          //   path: '/attendance',
          //   builder: (context, state) => const AttendanceListScreen(),
          //   routes: [
          //     GoRoute(
          //       path: 'add',
          //       builder: (context, state) => const AddEditAttendanceScreen(),
          //     ),
          //     GoRoute(
          //       path: 'edit',
          //       builder: (context, state) => AddEditAttendanceScreen(attendance: state.extra as Attendance?),
          //     ),
          //   ],
          // ),
          GoRoute(
            path: '/grades',
            builder: (context, state) => const GradeListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditGradeScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => AddEditGradeScreen(grade: state.extra as Grade?),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
