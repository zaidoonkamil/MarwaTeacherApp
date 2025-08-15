import 'dart:convert';

List<GetLessons> getLessonsFromJson(String str) => List<GetLessons>.from(json.decode(str).map((x) => GetLessons.fromJson(x)));

String getLessonsToJson(List<GetLessons> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLessons {
  int id;
  String title;
  List<String> images;
  String videoUrl;
  String pdfUrl;
  String description;
  int courseId;
  bool isLocked;
  DateTime createdAt;
  DateTime updatedAt;

  GetLessons({
    required this.id,
    required this.title,
    required this.images,
    required this.videoUrl,
    required this.pdfUrl,
    required this.description,
    required this.courseId,
    required this.isLocked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetLessons.fromJson(Map<String, dynamic> json) => GetLessons(
    id: json["id"],
    title: json["title"],
    images: List<String>.from(json["images"].map((x) => x)),
    videoUrl: json["videoUrl"],
    pdfUrl: json["pdfUrl"]??'',
    description: json["description"],
    courseId: json["courseId"],
    isLocked: json["isLocked"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "images": List<dynamic>.from(images.map((x) => x)),
    "videoUrl": videoUrl,
    "pdfUrl": pdfUrl,
    "isLocked": isLocked,
    "description": description,
    "courseId": courseId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
