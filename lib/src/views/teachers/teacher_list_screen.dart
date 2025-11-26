import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final TeacherRepository _teacherRepository = TeacherRepository();
  List<Teacher> _teachers = [];
  List<Teacher> _filteredTeachers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTeachers();
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshTeachers() async {
    final teachers = await _teacherRepository.getTeachers();
    setState(() {
      _teachers = teachers;
      _filteredTeachers = teachers;
    });
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeachers = _teachers.where((teacher) {
        return teacher.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _deleteTeacher(int id) async {
    await _teacherRepository.deleteTeacher(id);
    _refreshTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search teachers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ),
      body: _filteredTeachers.isEmpty
          ? const Center(child: Text('No teachers found.'))
          : ListView.builder(
              itemCount: _filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacher = _filteredTeachers[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(teacher.name),
                  subtitle: Text(teacher.subject),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTeacher(teacher.id!),
                  ),
                  onTap: () async {
                    await context.push('/teachers/details', extra: teacher);
                    _refreshTeachers();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/teachers/add');
          _refreshTeachers();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
