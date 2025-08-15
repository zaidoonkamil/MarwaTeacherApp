import 'dart:convert';

GetNameUser getNameUserFromJson(String str) => GetNameUser.fromJson(json.decode(str));

String getNameUserToJson(GetNameUser data) => json.encode(data.toJson());

class GetNameUser {
  Pagination2 pagination2;
  List<User> users;

  GetNameUser({
    required this.pagination2,
    required this.users,
  });

  factory GetNameUser.fromJson(Map<String, dynamic> json) => GetNameUser(
    pagination2: Pagination2.fromJson({
      "totalItems": json["totalItems"],
      "totalPages": json["totalPages"],
      "currentPage": json["currentPage"],
    }),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalItems": pagination2.totalItems,
    "totalPages": pagination2.totalPages,
    "currentPage": pagination2.currentPage,
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class Pagination2 {
  int totalItems;
  int totalPages;
  int currentPage;

  Pagination2({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });

  factory Pagination2.fromJson(Map<String, dynamic> json) => Pagination2(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
}

class User {
  int id;
  String name;
  String phone;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    role: json["role"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "role": role,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
