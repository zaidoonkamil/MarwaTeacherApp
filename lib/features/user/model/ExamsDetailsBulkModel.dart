// To parse this JSON data, do
//
//     final examsDetailsBulkModel = examsDetailsBulkModelFromJson(jsonString);

import 'dart:convert';

List<ExamsDetailsBulkModel> examsDetailsBulkModelFromJson(String str) => List<ExamsDetailsBulkModel>.from(json.decode(str).map((x) => ExamsDetailsBulkModel.fromJson(x)));

String examsDetailsBulkModelToJson(List<ExamsDetailsBulkModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExamsDetailsBulkModel {
  int id;
  String text;

  ExamsDetailsBulkModel({
    required this.id,
    required this.text,
  });

  factory ExamsDetailsBulkModel.fromJson(Map<String, dynamic> json) => ExamsDetailsBulkModel(
    id: json["id"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
  };
}
