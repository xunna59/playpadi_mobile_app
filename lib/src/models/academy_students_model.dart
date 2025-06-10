class AcademyStudents {
  final List<Student> students;

  AcademyStudents({required this.students});

  factory AcademyStudents.fromJson(dynamic json) {
    if (json is Map<String, dynamic> && json.containsKey('data')) {
      return AcademyStudents(
        students:
            (json['data'] as List<dynamic>)
                .map((e) => Student.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is List) {
      // json is a list directly
      return AcademyStudents(
        students:
            json
                .map((e) => Student.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      // Empty fallback
      return AcademyStudents(students: []);
    }
  }
}

class Student {
  final String firstName;
  final String? displayPicture;

  Student({required this.firstName, this.displayPicture});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      firstName: json['name']?.toString() ?? '',
      displayPicture: json['image']?.toString(),
    );
  }
}
