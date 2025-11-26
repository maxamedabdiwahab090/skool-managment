class Teacher {
  int? id;
  String name;
  String? subject;
  String? phoneNumber;

  Teacher({
    this.id,
    required this.name,
    this.subject,
    this.phoneNumber,
  });

  factory Teacher.fromMap(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        name: json["name"],
        subject: json["subject"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "subject": subject,
        "phone_number": phoneNumber,
      };
}
