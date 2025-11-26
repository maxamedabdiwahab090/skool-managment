import 'package:flutter/material.dart';
import 'package:myapp/src/models/teacher.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';

class AddEditTeacherScreen extends StatefulWidget {
  final Teacher? teacher;

  const AddEditTeacherScreen({super.key, this.teacher});

  @override
  AddEditTeacherScreenState createState() => AddEditTeacherScreenState();
}

class AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _subject;

  final TeacherRepository _teacherRepository = TeacherRepository();

  @override
  void initState() {
    super.initState();
    _name = widget.teacher?.name ?? '';
    _subject = widget.teacher?.subject ?? '';
  }

  void _saveTeacher() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final teacher = Teacher(
        id: widget.teacher?.id,
        name: _name,
        subject: _subject,
      );
      if (widget.teacher == null) {
        await _teacherRepository.createTeacher(teacher);
      } else {
        await _teacherRepository.updateTeacher(teacher);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher == null ? 'Add Teacher' : 'Edit Teacher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _subject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  icon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
                onSaved: (value) => _subject = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTeacher,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
