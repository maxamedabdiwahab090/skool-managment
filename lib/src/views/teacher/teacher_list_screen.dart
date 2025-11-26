import 'package:flutter/material.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';
import 'package:myapp/src/views/teacher/add_edit_teacher_screen.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  TeacherListScreenState createState() => TeacherListScreenState();
}

class TeacherListScreenState extends State<TeacherListScreen> {
  final _teacherRepository = TeacherRepository();
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherRepository.getAllTeachers();
  }

  Future<void> _refreshTeachers() async {
    setState(() {
      _teachersFuture = _teacherRepository.getAllTeachers();
    });
  }

  void _navigateToAddEditScreen([Teacher? teacher]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditTeacherScreen(teacher: teacher),
      ),
    ).then((_) => _refreshTeachers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshTeachers,
        child: FutureBuilder<List<Teacher>>(
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
                  subtitle: Text("Subject: ${teacher.subject ?? 'N/A'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToAddEditScreen(teacher),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _teacherRepository.deleteTeacher(teacher.id!);
                          _refreshTeachers();
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
