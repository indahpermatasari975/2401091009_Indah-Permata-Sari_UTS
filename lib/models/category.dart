// To parse this JSON data, do
//
//     final modelCategoryMasakan = modelCategoryMasakanFromJson(jsonString);

import 'dart:convert';

ModelCategoryMasakan modelCategoryMasakanFromJson(String str) => ModelCategoryMasakan.fromJson(json.decode(str));

String modelCategoryMasakanToJson(ModelCategoryMasakan data) => json.encode(data.toJson());

class ModelCategoryMasakan {
  List<Category> categories;

  ModelCategoryMasakan({
    required this.categories,
  });

  factory ModelCategoryMasakan.fromJson(Map<String, dynamic> json) => ModelCategoryMasakan(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  String idCategory;
  String strCategory;
  String strCategoryThumb;
  String strCategoryDescription;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    idCategory: json["idCategory"],
    strCategory: json["strCategory"],
    strCategoryThumb: json["strCategoryThumb"],
    strCategoryDescription: json["strCategoryDescription"],
  );

  Map<String, dynamic> toJson() => {
    "idCategory": idCategory,
    "strCategory": strCategory,
    "strCategoryThumb": strCategoryThumb,
    "strCategoryDescription": strCategoryDescription,
  };
}
