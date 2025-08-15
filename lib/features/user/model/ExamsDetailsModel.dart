import 'dart:convert';

List<ExamsDetailsModel> examsDetailsModelFromJson(String str) => List<ExamsDetailsModel>.from(json.decode(str).map((x) => ExamsDetailsModel.fromJson(x)));

String examsDetailsModelToJson(List<ExamsDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamsDetailsModel {
  int id;
  String text;
  int examId;
  DateTime createdAt;
  DateTime updatedAt;
  List<Choice> choices;
  Exam exam;

  ExamsDetailsModel({
    required this.id,
    required this.text,
    required this.examId,
    required this.createdAt,
    required this.updatedAt,
    required this.choices,
    required this.exam,
  });

  factory ExamsDetailsModel.fromJson(Map<String, dynamic> json) => ExamsDetailsModel(
    id: json["id"],
    text: json["text"],
    examId: json["examId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    choices: List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
    exam: Exam.fromJson(json["exam"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "examId": examId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "choices": List<dynamic>.from(choices.map((x) => x.toJson())),
    "exam": exam.toJson(),
  };
}

class Choice {
  int id;
  String text;
  bool isCorrect;
  int questionId;
  DateTime createdAt;
  DateTime updatedAt;

  Choice({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.questionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
    id: json["id"],
    text: json["text"],
    isCorrect: json["isCorrect"],
    questionId: json["questionId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "isCorrect": isCorrect,
    "questionId": questionId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Exam {
  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;

  Exam({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
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
