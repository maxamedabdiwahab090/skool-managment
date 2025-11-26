import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  TeacherListScreenState createState() => TeacherListScreenState();
}

class TeacherListScreenState extends State<TeacherListScreen> {
  final _teacherRepository = TeacherRepository();
  late Future<List<Teacher>> _teachersFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherRepository.getTeachers();
  }

  Future<void> _refreshTeachers() async {
    setState(() {
      _teachersFuture = _teacherRepository.getTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
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

                  final teachers = snapshot.data!.where((teacher) {
                    final nameLower = teacher.name.toLowerCase();
                    final searchLower = _searchQuery.toLowerCase();
                    return nameLower.contains(searchLower);
                  }).toList();

                  return ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      return _buildTeacherCard(teacher, index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/teachers/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          labelText: 'Search by name',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherCard(Teacher teacher, int index) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(radius: 30, child: Icon(Icons.school)),
        title: Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Subject: ${teacher.subject}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => context.go('/teachers/edit', extra: teacher),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _teacherRepository.deleteTeacher(teacher.id!);
                _refreshTeachers();
              },
            ),
          ],
        ),
      ),
    );
  }
}
