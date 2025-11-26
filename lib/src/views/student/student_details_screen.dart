import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (student.photoPath != null)
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: FileImage(File(student.photoPath!)),
                ),
              ),
            const SizedBox(height: 20),
            Text('Name: ${student.name}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('Roll Number: ${student.rollNumber ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            // Add more details here
          ],
        ),
      ),
    );
  }
}
