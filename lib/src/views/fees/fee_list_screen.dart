import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/models/fee.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/fee_repository.dart';
import 'package:myapp/src/repositories/student_repository.dart';

class FeeListScreen extends StatefulWidget {
  const FeeListScreen({super.key});

  @override
  FeeListScreenState createState() => FeeListScreenState();
}

class FeeListScreenState extends State<FeeListScreen> {
  final FeeRepository _feeRepository = FeeRepository();
  final StudentRepository _studentRepository = StudentRepository();
  late Future<List<Fee>> _fees;
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _fees = _feeRepository.getFees();
    _students = _studentRepository.getAllStudents();
  }

  void _refreshFees() {
    setState(() {
      _fees = _feeRepository.getFees();
    });
  }

  void _deleteFee(int id) async {
    await _feeRepository.deleteFee(id);
    _refreshFees();
  }

  Student? _findStudentById(List<Student> students, int id) {
    try {
      return students.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([_fees, _students]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data![0] as List).isEmpty) {
            return const Center(child: Text('No fees found.'));
          }

          final fees = snapshot.data![0] as List<Fee>;
          final students = snapshot.data![1] as List<Student>;

          return ListView.builder(
            itemCount: fees.length,
            itemBuilder: (context, index) {
              final fee = fees[index];
              final student = _findStudentById(students, fee.studentId);
              return ListTile(
                title: Text(student?.name ?? 'Unknown Student'),
                subtitle: Text('Amount: \$${fee.amount}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteFee(fee.id!),
                ),
                onTap: () async {
                  await context.push('/fees/edit', extra: fee);
                  _refreshFees();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/fees/add');
          _refreshFees();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
