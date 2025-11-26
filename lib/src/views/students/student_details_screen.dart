
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/students/edit', extra: student);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (student.photoPath.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(student.photoPath),
                ),
              ),
            const SizedBox(height: 20),
            Text('Name: ${student.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Class: ${student.className}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Date of Birth: ${student.dateOfBirth ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Address: ${student.address ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
