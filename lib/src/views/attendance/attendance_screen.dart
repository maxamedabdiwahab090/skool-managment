import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/models/attendance.dart';
import 'package:myapp/src/repositories/student_repository.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';
import 'package:myapp/src/repositories/attendance_repository.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  final StudentRepository _studentRepository = StudentRepository();
  final TeacherRepository _teacherRepository = TeacherRepository();
  final AttendanceRepository _attendanceRepository = AttendanceRepository();

  late Future<List<Student>> _studentsFuture;
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _studentsFuture = _studentRepository.getAllStudents();
    _teachersFuture = _teacherRepository.getAllTeachers();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance - ${DateFormat.yMMMd().format(_selectedDate)}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Teachers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudentAttendanceList(),
          _buildTeacherAttendanceList(),
        ],
      ),
    );
  }

  Widget _buildStudentAttendanceList() {
    return FutureBuilder<List<Student>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No students found."));
        }

        final students = snapshot.data!;
        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return ListTile(
              title: Text(student.name),
              trailing: _buildAttendanceSwitch(
                studentId: student.id,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTeacherAttendanceList() {
    return FutureBuilder<List<Teacher>>(
      future: _teachersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No teachers found."));
        }

        final teachers = snapshot.data!;
        return ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return ListTile(
              title: Text(teacher.name),
              trailing: _buildAttendanceSwitch(
                teacherId: teacher.id,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAttendanceSwitch({int? studentId, int? teacherId}) {
    return FutureBuilder<List<Attendance>>(
      future: studentId != null
          ? _attendanceRepository.getStudentAttendanceByDate(_selectedDate)
          : _attendanceRepository.getTeacherAttendanceByDate(_selectedDate),
      builder: (context, snapshot) {
        Attendance? attendanceRecord;
        if (snapshot.hasData) {
          final attendanceList = snapshot.data!;
            if (studentId != null) {
                try {
                attendanceRecord = attendanceList.firstWhere((att) => att.studentId == studentId);
                } catch (e) {
                attendanceRecord = null;
                }
            } else {
                try {
                attendanceRecord = attendanceList.firstWhere((att) => att.teacherId == teacherId);
                } catch (e) {
                attendanceRecord = null;
                }
            }
        }

        bool isPresent = attendanceRecord?.status == 'Present';

        return Switch(
          value: isPresent,
          onChanged: (value) async {
            final newStatus = value ? 'Present' : 'Absent';
            final attendance = Attendance(
              id: attendanceRecord?.id,
              studentId: studentId,
              teacherId: teacherId,
              date: _selectedDate,
              status: newStatus,
            );

            if (attendanceRecord?.id != null) {
              if (studentId != null) {
                await _attendanceRepository.updateStudentAttendance(attendance);
              } else {
                await _attendanceRepository.updateTeacherAttendance(attendance);
              }
            } else {
              if (studentId != null) {
                await _attendanceRepository.createStudentAttendance(attendance);
              } else {
                await _attendanceRepository.createTeacherAttendance(attendance);
              }
            }
            setState(() {});
          },
        );
      },
    );
  }
}
