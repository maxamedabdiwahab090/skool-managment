import 'package:flutter/material.dart';
import 'package:myapp/src/repositories/student_repository.dart';
import 'package:myapp/src/repositories/teacher_repository.dart';
import 'package:myapp/src/repositories/fee_repository.dart';
import 'package:myapp/src/repositories/grade_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  final TeacherRepository _teacherRepository = TeacherRepository();
  final FeeRepository _feeRepository = FeeRepository();
  final GradeRepository _gradeRepository = GradeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(26),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 20),
            _buildStatsCards(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the School Management System',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Manage students, teachers, and attendance with ease.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          _studentRepository.getAllStudents(),
          _teacherRepository.getTeachers(),
          _feeRepository.getFees(),
          _gradeRepository.getGrades(),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final studentCount = snapshot.data![0].length;
            final teacherCount = snapshot.data![1].length;
            final feeCount = snapshot.data![2].length;
            final gradeCount = snapshot.data![3].length;

            final stats = [
              {
                'icon': Icons.people,
                'label': 'Students',
                'count': studentCount.toString(),
                'color': Colors.orange,
              },
              {
                'icon': Icons.school,
                'label': 'Teachers',
                'count': teacherCount.toString(),
                'color': Colors.blue,
              },
              {
                'icon': Icons.payment,
                'label': 'Fees',
                'count': feeCount.toString(),
                'color': Colors.green,
              },
              {
                'icon': Icons.grading,
                'label': 'Grades',
                'count': gradeCount.toString(),
                'color': Colors.red,
              },
            ];

            return LayoutBuilder(builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final stat = stats[index];
                  return _buildStatCard(
                    context,
                    icon: stat['icon'] as IconData,
                    label: stat['label'] as String,
                    count: stat['count'] as String,
                    color: stat['color'] as Color,
                  );
                },
              );
            });
          }
        });
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String label, required String count, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withAlpha(204), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  count,
                  style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
