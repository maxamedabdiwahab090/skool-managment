class Student {
  int? id;
  String name;
  String? rollNumber;
  String? photoPath;
  int? classId;
  int? sectionId;

  Student({
    this.id,
    required this.name,
    this.rollNumber,
    this.photoPath,
    this.classId,
    this.sectionId,
  });

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"],
        rollNumber: json["roll_number"],
        photoPath: json["photo_path"],
        classId: json["class_id"],
        sectionId: json["section_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "roll_number": rollNumber,
        "photo_path": photoPath,
        "class_id": classId,
        "section_id": sectionId,
      };
}
