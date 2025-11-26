import 'package:flutter/material.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/student_repository.dart';
import 'package:myapp/src/repositories/attendance_repository.dart';
import 'package:myapp/src/models/attendance.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  late Future<List<Student>> _students;
  final Map<int, bool> _attendanceStatus = {};

  @override
  void initState() {
    super.initState();
    _students = _studentRepository.getAllStudents();
    _students.then((students) {
      for (var student in students) {
        _attendanceStatus[student.id!] = true;
      }
    });
  }

  void _saveAttendance() async {
    final DateTime now = DateTime.now();
    for (var studentId in _attendanceStatus.keys) {
      final isPresent = _attendanceStatus[studentId]!;
      final attendance = Attendance(
        studentId: studentId,
        date: now,
        isPresent: isPresent,
      );
      await _attendanceRepository.markAttendance(attendance);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: FutureBuilder<List<Student>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return SwitchListTile(
                title: Text(student.name),
                value: _attendanceStatus[student.id!] ?? true,
                onChanged: (bool value) {
                  setState(() {
                    _attendanceStatus[student.id!] = value;
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAttendance,
        child: const Icon(Icons.save),
      ),
    );
  }
}
