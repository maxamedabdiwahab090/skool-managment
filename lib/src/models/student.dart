class Student {
  final int? id;
  final String name;
  final String className;
  final String rollNumber;
  final String photoPath;
  final String? dateOfBirth;
  final String? address;

  Student({
    this.id,
    required this.name,
    required this.className,
    required this.rollNumber,
    required this.photoPath,
    this.dateOfBirth,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'className': className,
      'rollNumber': rollNumber,
      'photoPath': photoPath,
      'dateOfBirth': dateOfBirth,
      'address': address,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      className: map['className'],
      rollNumber: map['rollNumber'],
      photoPath: map['photoPath'],
      dateOfBirth: map['dateOfBirth'],
      address: map['address'],
    );
  }
}
