import 'dart:convert';

List<GetAds> getAdsFromJson(String str) => List<GetAds>.from(json.decode(str).map((x) => GetAds.fromJson(x)));

String getAdsToJson(List<GetAds> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAds {
  Pagination pagination;
  List<Ad> ads;


  GetAds({
    required this.pagination,
    required this.ads,
  });

  factory GetAds.fromJson(Map<String, dynamic> json) => GetAds(
    pagination: Pagination.fromJson({
      "total": json["total"],
      "totalPages": json["totalPages"],
      "page": json["page"],
    }),
    ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
  };
}

class Ad {
  int id;
  List<String> images;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Ad({
    required this.id,
    required this.images,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
    id: json["id"],
    images: List<String>.from(json["images"].map((x) => x)),
    title: json["title"],
    description: json["description"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "images": List<dynamic>.from(images.map((x) => x)),
    "title": title,
    "description": description,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Pagination {
  int total;
  int totalPages;
  int currentPage;

  Pagination({
    required this.total,
    required this.totalPages,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    totalPages: json["totalPages"],
    currentPage: json["page"],
  );

}
