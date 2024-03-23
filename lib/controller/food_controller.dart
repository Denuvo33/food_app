import 'package:food_app/model/food_model.dart';
import 'package:food_app/service/remote_service.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  var foodList = <FoodModel>[].obs;
  var searching = false.obs;
  var originalFoodList = <FoodModel>[].obs;
  var isSort = false.obs;
  var lastSearch = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    var food = await RemoteService.fetchData();
    foodList.value = food;
    originalFoodList.assignAll(foodList);
    searching(true);
  }

  void searchFood(name) async {
    var food = await RemoteService.searchData(name);
    foodList.value = food;
    originalFoodList.assignAll(foodList);
    searching(true);
  }
}
