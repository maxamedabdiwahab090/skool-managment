class Attendance {
  int? id;
  int? studentId;
  int? teacherId;
  DateTime date;
  String status;

  Attendance({
    this.id,
    this.studentId,
    this.teacherId,
    required this.date,
    required this.status,
  });

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        studentId: json["student_id"],
        teacherId: json["teacher_id"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "student_id": studentId,
        "teacher_id": teacherId,
        "date": date.toIso8601String(),
        "status": status,
      };
}
