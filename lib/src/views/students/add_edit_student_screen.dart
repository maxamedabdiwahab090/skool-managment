
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
  late String _className;
  late String _rollNumber;
  XFile? _photo;

  final StudentRepository _studentRepository = StudentRepository();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = widget.student?.name ?? '';
    _className = widget.student?.className ?? '';
    _rollNumber = widget.student?.rollNumber ?? '';
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = image;
    });
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String photoPath = '';
      if (_photo != null) {
        photoPath = _photo!.path;
      } else if (widget.student?.photoPath != null) {
        photoPath = widget.student!.photoPath;
      }

      final student = Student(
        id: widget.student?.id,
        name: _name,
        className: _className,
        rollNumber: _rollNumber,
        photoPath: photoPath,
      );
      if (widget.student == null) {
        await _studentRepository.createStudent(student);
      } else {
        await _studentRepository.updateStudent(student);
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
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _photo != null
                        ? FileImage(File(_photo!.path))
                        : (widget.student?.photoPath != null && widget.student!.photoPath.isNotEmpty
                            ? NetworkImage(widget.student!.photoPath)
                            : const AssetImage('assets/placeholder.png'))
                            as ImageProvider,
                    child: const Icon(Icons.camera_alt, size: 30),
                  ),
                ),
                const SizedBox(height: 20),
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
                  initialValue: _className,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    icon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a class';
                    }
                    return null;
                  },
                  onSaved: (value) => _className = value!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _rollNumber,
                  decoration: const InputDecoration(
                    labelText: 'Roll Number',
                    icon: Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a roll number';
                    }
                    return null;
                  },
                  onSaved: (value) => _rollNumber = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
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
      ),
    );
  }
}
