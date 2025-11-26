import 'package:flutter/material.dart';
import 'package:myapp/src/models/fee.dart';
import 'package:myapp/src/models/student.dart';
import 'package:myapp/src/repositories/fee_repository.dart';
import 'package:myapp/src/repositories/student_repository.dart';

class AddEditFeeScreen extends StatefulWidget {
  final Fee? fee;

  const AddEditFeeScreen({super.key, this.fee});

  @override
  AddEditFeeScreenState createState() => AddEditFeeScreenState();
}

class AddEditFeeScreenState extends State<AddEditFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _studentId;
  late double _amount;
  late DateTime _date;

  final FeeRepository _feeRepository = FeeRepository();
  final StudentRepository _studentRepository = StudentRepository();
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _students = _studentRepository.getAllStudents();
    _studentId = widget.fee?.studentId;
    _amount = widget.fee?.amount ?? 0.0;
    _date = widget.fee?.date ?? DateTime.now();
  }

  void _saveFee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final fee = Fee(
        id: widget.fee?.id,
        studentId: _studentId!,
        amount: _amount,
        date: _date,
      );
      if (widget.fee == null) {
        await _feeRepository.createFee(fee);
      } else {
        await _feeRepository.updateFee(fee);
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
        title: Text(widget.fee == null ? 'Add Fee' : 'Edit Fee'),
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
                    decoration: const InputDecoration(
                      labelText: 'Student',
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
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
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  icon: Icon(Icons.payment),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFee,
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
