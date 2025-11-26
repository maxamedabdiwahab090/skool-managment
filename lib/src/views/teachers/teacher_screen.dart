import 'package:flutter/material.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';
import 'package:myapp/src/views/teachers/add_edit_teacher_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  TeacherScreenState createState() => TeacherScreenState();
}

class TeacherScreenState extends State<TeacherScreen> {
  final TeacherRepository _teacherRepository = TeacherRepository();
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  void _loadTeachers() {
    setState(() {
      _teachersFuture = _teacherRepository.getTeachers();
    });
  }

  void _navigateToAddEditTeacherScreen([Teacher? teacher]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTeacherScreen(teacher: teacher)),
    );
    _loadTeachers();
  }

  void _deleteTeacher(int id) async {
    await _teacherRepository.deleteTeacher(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher deleted successfully')),
      );
    }
    _loadTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
      ),
      body: FutureBuilder<List<Teacher>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No teachers found.'));
          } else {
            final teachers = snapshot.data!;
            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];
                return ListTile(
                  title: Text(teacher.name),
                  subtitle: Text(teacher.subject),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToAddEditTeacherScreen(teacher),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTeacher(teacher.id!),
                      ),
                    ],
                  ),
                  onTap: () { // TODO: Navigate to teacher details screen
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditTeacherScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
