import 'dart:convert';

List<CoursesModel> coursesModelFromJson(String str) => List<CoursesModel>.from(json.decode(str).map((x) => CoursesModel.fromJson(x)));

String coursesModelToJson(List<CoursesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoursesModel {
  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;

  CoursesModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
    id: json["id"],
    title: json["title"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
