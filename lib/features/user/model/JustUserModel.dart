import 'dart:convert';

JustUserModel justUserModelFromJson(String str) => JustUserModel.fromJson(json.decode(str));

String justUserModelToJson(JustUserModel data) => json.encode(data.toJson());

class JustUserModel {
  List<Student> students;

  JustUserModel({
    required this.students,
  });

  factory JustUserModel.fromJson(Map<String, dynamic> json) => JustUserModel(
    students: List<Student>.from(json["students"].map((x) => Student.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "students": List<dynamic>.from(students.map((x) => x.toJson())),
  };
}

class Student {
  int id;
  String name;
  String phone;
  Grade grade;

  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.grade,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    grade: Grade.fromJson(json["grade"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "grade": grade.toJson(),
  };
}

class Grade {
  String unitName;
  String lectureName;
  List<String> lectureNos;
  List<int> examGrades;
  List<int> originalGrades;
  List<int> resitGrades1;
  List<int> resitGrades2;

  Grade({
    required this.unitName,
    required this.lectureNos,
    required this.examGrades,
    required this.lectureName,
    required this.originalGrades,
    required this.resitGrades1,
    required this.resitGrades2,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    unitName: json["unitName"],
    lectureName: json["lectureName"],
    lectureNos: List<String>.from(json["lectureNos"].map((x) => x)),
    examGrades: List<int>.from(json["examGrades"].map((x) => x)),
    originalGrades: List<int>.from(json["originalGrades"].map((x) => x)),
    resitGrades1: List<int>.from(json["resitGrades1"].map((x) => x)),
    resitGrades2: List<int>.from(json["resitGrades2"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "unitName": unitName,
    "lectureName": lectureName,
    "lectureNos": List<dynamic>.from(lectureNos.map((x) => x)),
    "examGrades": List<dynamic>.from(examGrades.map((x) => x)),
    "originalGrades": List<dynamic>.from(originalGrades.map((x) => x)),
    "resitGrades1": List<dynamic>.from(resitGrades1.map((x) => x)),
    "resitGrades2": List<dynamic>.from(resitGrades2.map((x) => x)),
  };
}
