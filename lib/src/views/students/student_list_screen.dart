import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/student_repository.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshStudents() async {
    final students = await _studentRepository.getAllStudents();
    setState(() {
      _students = students;
      _filteredStudents = students;
    });
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((student) {
        return student.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _deleteStudent(int id) async {
    await _studentRepository.deleteStudent(id);
    _refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search students...',
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
      body: _filteredStudents.isEmpty
          ? const Center(child: Text('No students found.'))
          : ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: student.photoPath.isNotEmpty
                        ? NetworkImage(student.photoPath)
                        : const AssetImage('assets/placeholder.png') as ImageProvider,
                  ),
                  title: Text(student.name),
                  subtitle: Text(student.className),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteStudent(student.id!),
                  ),
                  onTap: () async {
                    await context.push('/students/details', extra: student);
                    _refreshStudents();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/students/add');
          _refreshStudents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
