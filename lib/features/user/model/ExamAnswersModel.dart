import 'dart:convert';

List<ExamAnswersModel> examAnswersModelFromJson(String str) => List<ExamAnswersModel>.from(json.decode(str).map((x) => ExamAnswersModel.fromJson(x)));

String examAnswersModelToJson(List<ExamAnswersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamAnswersModel {
  int id;
  int userId;
  int examId;
  List<String> fileUrl;
  DateTime createdAt;
  DateTime updatedAt;
  Userr user;

  ExamAnswersModel({
    required this.id,
    required this.userId,
    required this.examId,
    required this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory ExamAnswersModel.fromJson(Map<String, dynamic> json) => ExamAnswersModel(
    id: json["id"],
    userId: json["userId"],
    examId: json["examId"],
    fileUrl: List<String>.from(json["fileUrl"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    user: Userr.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "examId": examId,
    "fileUrl": List<dynamic>.from(fileUrl.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}

class Userr {
  int id;
  String name;

  Userr({
    required this.id,
    required this.name,
  });

  factory Userr.fromJson(Map<String, dynamic> json) => Userr(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
