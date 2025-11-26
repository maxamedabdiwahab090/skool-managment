import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/teacher.dart';

class TeacherDetailsScreen extends StatelessWidget {
  final Teacher teacher;

  const TeacherDetailsScreen({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teacher.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/teachers/edit', extra: teacher);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (teacher.photoPath != null && teacher.photoPath!.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(teacher.photoPath!),
                ),
              ),
            const SizedBox(height: 20),
            Text('Name: ${teacher.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Subject: ${teacher.subject}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
