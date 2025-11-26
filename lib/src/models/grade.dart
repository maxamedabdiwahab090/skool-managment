class Grade {
  final int? id;
  final int studentId;
  final String subject;
  final double grade;

  Grade({
    this.id,
    required this.studentId,
    required this.subject,
    required this.grade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subject': subject,
      'grade': grade,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      studentId: map['studentId'],
      subject: map['subject'],
      grade: map['grade'],
    );
  }
}
