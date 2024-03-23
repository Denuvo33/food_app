import 'package:food_app/controller/food_controller.dart';
import 'package:food_app/database/database_reference.dart';
import 'package:food_app/model/food_model.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var foodList = <FoodModel>[].obs;
  var controller = Get.find<FoodController>();
  DatabaseReference? databaseReference;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    databaseReference = DatabaseReference();
    await databaseReference!.database();
    favoriteList();
  }

  void saveFood(Map<String, dynamic> row) {
    databaseReference!.insert(row);
    favoriteList();
  }

  void favoriteList() async {
    foodList.value = await databaseReference!.all();
  }

  void deleteAll() {
    databaseReference!.deleteAll();
  }

  void delete(int id) {
    databaseReference!.delete(id);

    favoriteList();
  }
}
