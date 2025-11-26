import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/fee.dart';
import 'package:myapp/src/repositories/fee_repository.dart';
import 'package:myapp/src/views/fees/add_edit_fee_screen.dart';

class FeeScreen extends StatefulWidget {
  const FeeScreen({super.key});

  @override
  FeeScreenState createState() => FeeScreenState();
}

class FeeScreenState extends State<FeeScreen> {
  final FeeRepository _feeRepository = FeeRepository();
  late Future<List<Fee>> _feesFuture;

  @override
  void initState() {
    super.initState();
    _loadFees();
  }

  void _loadFees() {
    setState(() {
      _feesFuture = _feeRepository.getFees();
    });
  }

  void _navigateToAddEditFeeScreen([Fee? fee]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditFeeScreen(fee: fee)),
    );
    _loadFees();
  }

  void _deleteFee(int id) async {
    await _feeRepository.deleteFee(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fee record deleted successfully')),
      );
    }
    _loadFees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fees Management',
          style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withAlpha(179),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface.withAlpha(230),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Fee>>(
          future: _feesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No fee records found.'));
            } else {
              final fees = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: fees.length,
                itemBuilder: (context, index) {
                  final fee = fees[index];
                  return _buildFeeCard(fee);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditFeeScreen(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFeeCard(Fee fee) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          'Student ID: ${fee.studentId}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Amount: \$${fee.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${DateFormat.yMMMd().format(fee.date)}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                  onPressed: () => _navigateToAddEditFeeScreen(fee),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteFee(fee.id!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
