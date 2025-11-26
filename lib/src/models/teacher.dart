
class Teacher {
  final int? id;
  final String name;
  final String subject;
  final String? photoPath;

  Teacher({this.id, required this.name, required this.subject, this.photoPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'photoPath': photoPath,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      name: map['name'],
      subject: map['subject'],
      photoPath: map['photoPath'],
    );
  }
}
