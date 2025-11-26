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
  String? _subject;
  String? _phoneNumber;
  final _teacherRepository = TeacherRepository();

  @override
  void initState() {
    super.initState();
    _name = widget.teacher?.name ?? '';
    _subject = widget.teacher?.subject;
    _phoneNumber = widget.teacher?.phoneNumber;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTeacher = Teacher(
        id: widget.teacher?.id,
        name: _name,
        subject: _subject,
        phoneNumber: _phoneNumber,
      );

      if (widget.teacher == null) {
        _teacherRepository.createTeacher(newTeacher);
      } else {
        _teacherRepository.updateTeacher(newTeacher);
      }

      Navigator.of(context).pop();
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
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _subject,
                decoration: const InputDecoration(labelText: 'Subject'),
                onSaved: (value) => _subject = value,
              ),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) => _phoneNumber = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
