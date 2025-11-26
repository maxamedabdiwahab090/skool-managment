import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/grade.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/grade_repository.dart';
import 'package:myapp/src/repositories/student_repository.dart';

class GradeListScreen extends StatefulWidget {
  const GradeListScreen({super.key});

  @override
  GradeListScreenState createState() => GradeListScreenState();
}

class GradeListScreenState extends State<GradeListScreen> {
  final GradeRepository _gradeRepository = GradeRepository();
  final StudentRepository _studentRepository = StudentRepository();
  late Future<List<Grade>> _grades;
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _grades = _gradeRepository.getGrades();
    _students = _studentRepository.getAllStudents();
  }

  void _refreshGrades() {
    setState(() {
      _grades = _gradeRepository.getGrades();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/grades/add');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_grades, _students]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
            return const Center(child: Text('No grades found.'));
          }

          final grades = snapshot.data![0] as List<Grade>;
          final students = snapshot.data![1] as List<Student>;

          return ListView.builder(
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final grade = grades[index];
              final student = students.firstWhere((s) => s.id == grade.studentId);
              return ListTile(
                title: Text(student.name),
                subtitle: Text('${grade.subject}: ${grade.grade}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await context.push('/grades/edit', extra: grade);
                        _refreshGrades();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _gradeRepository.deleteGrade(grade.id!);
                        _refreshGrades();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
