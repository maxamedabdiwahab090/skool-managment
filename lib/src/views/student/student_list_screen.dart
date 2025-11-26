import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/student_repository.dart';
import 'package:myapp/src/views/student/add_edit_student_screen.dart';
import 'package:myapp/src/views/student/student_details_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  StudentListScreenState createState() => StudentListScreenState();
}

class StudentListScreenState extends State<StudentListScreen> {
  final _studentRepository = StudentRepository();
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _studentRepository.getAllStudents();
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _studentsFuture = _studentRepository.getAllStudents();
    });
  }

  void _navigateToAddEditScreen([Student? student]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditStudentScreen(student: student),
      ),
    ).then((_) => _refreshStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshStudents,
        child: FutureBuilder<List<Student>>(
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
                  leading: student.photoPath != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(student.photoPath!)),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(student.name),
                  subtitle: Text("Roll No: ${student.rollNumber ?? 'N/A'}"),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentDetailsScreen(student: student),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToAddEditScreen(student),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _studentRepository.deleteStudent(student.id!);
                          _refreshStudents();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
