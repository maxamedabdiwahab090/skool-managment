import 'package:flutter/material.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/student_repository.dart';
import 'package:myapp/src/views/students/add_edit_student_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  StudentScreenState createState() => StudentScreenState();
}

class StudentScreenState extends State<StudentScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    setState(() {
      _studentsFuture = _studentRepository.getAllStudents();
    });
  }

  void _navigateToAddEditStudentScreen([Student? student]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditStudentScreen(student: student)),
    );
    _loadStudents();
  }

  void _deleteStudent(int id) async {
    await _studentRepository.deleteStudent(id);
    _loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          } else {
            final students = snapshot.data!;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student.name),
                  subtitle: Text('Class: ${student.className}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToAddEditStudentScreen(student),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteStudent(student.id!),
                      ),
                    ],
                  ),
                  onTap: () { // TODO: Navigate to student details screen
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditStudentScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
