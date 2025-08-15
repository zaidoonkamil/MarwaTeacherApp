import 'dart:convert';

List<ExamsModel> examsModelFromJson(String str) => List<ExamsModel>.from(json.decode(str).map((x) => ExamsModel.fromJson(x)));

String examsModelToJson(List<ExamsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamsModel {
  int id;
  String title;
  DateTime createdAt;
  QuestionCounts questionCounts;

  ExamsModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.questionCounts,
  });

  factory ExamsModel.fromJson(Map<String, dynamic> json) => ExamsModel(
    id: json["id"],
    title: json["title"],
    createdAt: DateTime.parse(json["createdAt"]),
    questionCounts: QuestionCounts.fromJson(json["questionCounts"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "createdAt": createdAt.toIso8601String(),
    "questionCounts": questionCounts.toJson(),
  };
}

class QuestionCounts {
  int text;
  int multipleChoice;

  QuestionCounts({
    required this.text,
    required this.multipleChoice,
  });

  factory QuestionCounts.fromJson(Map<String, dynamic> json) => QuestionCounts(
    text: json["text"],
    multipleChoice: json["multiple_choice"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "multiple_choice": multipleChoice,
  };
}
