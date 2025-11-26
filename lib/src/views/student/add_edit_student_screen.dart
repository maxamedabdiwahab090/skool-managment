import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/student_repository.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  AddEditStudentScreenState createState() => AddEditStudentScreenState();
}

class AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _rollNumber;
  String? _photoPath;
  final _studentRepository = StudentRepository();

  @override
  void initState() {
    super.initState();
    _name = widget.student?.name ?? '';
    _rollNumber = widget.student?.rollNumber;
    _photoPath = widget.student?.photoPath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newStudent = Student(
        id: widget.student?.id,
        name: _name,
        rollNumber: _rollNumber,
        photoPath: _photoPath,
      );

      if (widget.student == null) {
        _studentRepository.createStudent(newStudent);
      } else {
        _studentRepository.updateStudent(newStudent);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (_photoPath != null)
                Image.file(File(_photoPath!),
                    height: 150, width: 150, fit: BoxFit.cover),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Select Profile Photo'),
              ),
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
                initialValue: _rollNumber,
                decoration: const InputDecoration(labelText: 'Roll Number'),
                onSaved: (value) => _rollNumber = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
