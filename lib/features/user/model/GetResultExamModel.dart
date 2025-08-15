import 'dart:convert';

List<GetResultExamModel> getResultExamModelFromJson(String str) => List<GetResultExamModel>.from(json.decode(str).map((x) => GetResultExamModel.fromJson(x)));

String getResultExamModelToJson(List<GetResultExamModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetResultExamModel {
  int studentId;
  String studentName;
  int correctAnswers;
  int totalQuestions;
  String score;

  GetResultExamModel({
    required this.studentId,
    required this.studentName,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
  });

  factory GetResultExamModel.fromJson(Map<String, dynamic> json) => GetResultExamModel(
    studentId: json["studentId"],
    studentName: json["studentName"],
    correctAnswers: json["correctAnswers"],
    totalQuestions: json["totalQuestions"],
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "studentName": studentName,
    "correctAnswers": correctAnswers,
    "totalQuestions": totalQuestions,
    "score": score,
  };
}
