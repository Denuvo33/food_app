import 'package:get/get.dart';

class FoodModel {
  String? id, name, image, category, area, tags, instruction;
  int? tableId;
  RxBool isLiked = false.obs;

  FoodModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.category,
      var liked = false,
      this.tableId,
      required this.area,
      required this.instruction,
      required this.tags}) {
    isLiked(liked);
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['idMeal'],
      image: json['strMealThumb'],
      name: json['strMeal'],
      area: json['strArea'],
      category: json['strCategory'],
      tags: json['strTags'],
      tableId: json['id'],
      instruction: json['strInstructions'],
    );
  }
}

class FoodModelSorter {
  static int compareByName(FoodModel a, FoodModel b) {
    return a.name!.compareTo(b.name!);
  }
}
