import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/favorite_controller.dart';
import 'package:food_app/controller/food_controller.dart';
import 'package:food_app/view/food_details_page.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FavoriteController>();
    var foodController = Get.find<FoodController>();
    controller.favoriteList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: Obx(
        () => Container(
          margin: EdgeInsets.all(10),
          child: Visibility(
            visible: controller.foodList.isNotEmpty,
            replacement: Center(
              child: Text('You dont have any Favorite Food'),
            ),
            child: ListView.builder(
              itemCount:
                  controller.foodList.length, //controller.foodList.length,
              itemBuilder: (BuildContext context, int index) {
                var food = controller.foodList[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => FoodDetailsPage(
                        area: food.area,
                        category: food.category,
                        id: food.id,
                        image: food.image,
                        instruction: food.instruction,
                        name: food.name,
                        isLiked: true.obs,
                        tableId: food.tableId,
                        tags: food.tags));
                  },
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 120,
                            imageUrl: food.image.toString(),
                            errorWidget: (context, url, error) {
                              return SizedBox(
                                height: 180,
                                width: 160,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 120,
                                ),
                              );
                            },
                            placeholder: (context, url) {
                              return SizedBox(
                                height: 180,
                                width: 160,
                                child: Shimmer.fromColors(
                                    child: Card(),
                                    baseColor: Colors.grey,
                                    highlightColor: Colors.white),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              food.name.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text('Area: ${food.area}'),
                            Text('Category: ${food.category}'),
                          ],
                        )),
                        IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                                middleText:
                                    'Are you sure want to remove this food from your favorite page?',
                                onConfirm: () {
                                  controller.delete(food.tableId!);
                                  foodController
                                      .searchFood(foodController.lastSearch);
                                  Navigator.of(Get.overlayContext!).pop();
                                },
                                textCancel: 'No',
                                textConfirm: 'Yes');
                          },
                          icon: Icon(Icons.favorite),
                          iconSize: 45,
                          color: CupertinoColors.activeOrange,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
