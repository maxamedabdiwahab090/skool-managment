class Fee {
  final int? id;
  final int studentId;
  final double amount;
  final DateTime date;

  Fee({
    this.id,
    required this.studentId,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Fee.fromMap(Map<String, dynamic> map) {
    return Fee(
      id: map['id'],
      studentId: map['studentId'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
