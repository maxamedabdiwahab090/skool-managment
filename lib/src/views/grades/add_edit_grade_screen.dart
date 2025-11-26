import 'package:flutter/material.dart';
import 'package:myapp/src/models/grade.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/grade_repository.dart';
import 'package:myapp/src/repositories/student_repository.dart';

class AddEditGradeScreen extends StatefulWidget {
  final Grade? grade;

  const AddEditGradeScreen({super.key, this.grade});

  @override
  AddEditGradeScreenState createState() => AddEditGradeScreenState();
}

class AddEditGradeScreenState extends State<AddEditGradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final GradeRepository _gradeRepository = GradeRepository();
  final StudentRepository _studentRepository = StudentRepository();
  int? _studentId;
  late String _subject;
  late double _grade;
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _students = _studentRepository.getAllStudents();
    _studentId = widget.grade?.studentId;
    _subject = widget.grade?.subject ?? '';
    _grade = widget.grade?.grade ?? 0.0;
  }

  void _saveGrade() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newGrade = Grade(
        id: widget.grade?.id,
        studentId: _studentId!,
        subject: _subject,
        grade: _grade,
      );

      if (widget.grade == null) {
        await _gradeRepository.createGrade(newGrade);
      } else {
        await _gradeRepository.updateGrade(newGrade);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grade == null ? 'Add Grade' : 'Edit Grade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FutureBuilder<List<Student>>(
                future: _students,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final students = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    initialValue: _studentId,
                    decoration: const InputDecoration(labelText: 'Student'),
                    items: students.map((student) {
                      return DropdownMenuItem<int>(
                        value: student.id,
                        child: Text(student.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _studentId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a student';
                      }
                      return null;
                    },
                  );
                },
              ),
              TextFormField(
                initialValue: _subject,
                decoration: const InputDecoration(labelText: 'Subject'),
                onSaved: (value) => _subject = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _grade.toString(),
                decoration: const InputDecoration(labelText: 'Grade'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _grade = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a grade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveGrade,
                child: const Text('Save Grade'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
