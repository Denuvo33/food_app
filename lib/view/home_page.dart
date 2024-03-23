import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/favorite_controller.dart';
import 'package:food_app/controller/food_controller.dart';
import 'package:food_app/model/food_model.dart';
import 'package:food_app/view/food_details_page.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(FoodController());
    final TextEditingController search = TextEditingController();
    final favoriteController = Get.put(FavoriteController());
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Receipt'),
      ),
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                focusNode: focusNode,
                controller: search,
                elevation: MaterialStatePropertyAll(1),
                hintText: 'Search Food Name',
                trailing: [
                  IconButton(
                      onPressed: () {
                        controller.isSort(false);
                        controller.searching(false);
                        controller.searchFood(search.text);
                        controller.lastSearch.value = search.text;
                        focusNode.unfocus();
                      },
                      icon: Icon(Icons.send))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Sort by name'),
                  Switch(
                      value: controller.isSort.value,
                      onChanged: (value) {
                        controller.isSort.toggle();
                        if (value) {
                          controller.foodList
                              .sort(FoodModelSorter.compareByName);
                        } else {
                          controller.foodList
                              .assignAll(controller.originalFoodList);
                        }
                      })
                ],
              ),
              Visibility(
                visible: controller.searching.value,
                replacement: Center(child: CircularProgressIndicator()),
                child: Visibility(
                  visible: controller.foodList.isNotEmpty,
                  replacement: Center(
                    child: Text('No Food Found'),
                  ),
                  child: controller.foodList.isNotEmpty
                      ? Expanded(
                          child: GridView.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: List.generate(
                                  controller.foodList.length, (index) {
                                var food = controller.foodList[index];
                                for (var i = 0;
                                    i < favoriteController.foodList.length;
                                    i++) {
                                  if (favoriteController.foodList[i].name ==
                                      food.name) {
                                    food.isLiked(true);
                                    food.tableId =
                                        favoriteController.foodList[i].tableId!;
                                  } else {}
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        () => FoodDetailsPage(
                                              id: food.id,
                                              area: food.area,
                                              tableId: food.tableId ??
                                                  favoriteController
                                                          .foodList.length +
                                                      1,
                                              category: food.category,
                                              image: food.image,
                                              instruction: food.instruction,
                                              name: food.name,
                                              isLiked: food.isLiked,
                                              tags: food.tags ?? '',
                                            ),
                                        transition: Transition.topLevel);
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            child: CachedNetworkImage(
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              imageUrl: food.image!,
                                              errorWidget:
                                                  (context, url, error) {
                                                return Icon(
                                                    Icons.image_not_supported);
                                              },
                                              placeholder: (context, url) {
                                                return SizedBox(
                                                  height: 160,
                                                  width: 160,
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey,
                                                    highlightColor:
                                                        Colors.white,
                                                    child: const Card(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  food.name!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                  //   overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    if (food.isLiked.value) {
                                                      food.isLiked(false);
                                                      favoriteController.delete(
                                                          food.tableId!);
                                                    } else {
                                                      food.isLiked(true);
                                                      favoriteController
                                                          .saveFood({
                                                        'strMeal': food.name,
                                                        'strMealThumb':
                                                            food.image,
                                                        'strTags':
                                                            food.tags ?? '',
                                                        'strArea':
                                                            food.area ?? '',
                                                        'strCategory':
                                                            food.category ?? '',
                                                        'created_at':
                                                            DateTime.now()
                                                                .toString(),
                                                        'strInstructions':
                                                            food.instruction,
                                                      });
                                                    }
                                                  },
                                                  icon: food.isLiked.value
                                                      ? Icon(
                                                          Icons.favorite,
                                                          color: CupertinoColors
                                                              .activeOrange,
                                                          size: 40,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 40,
                                                        ))
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })),
                        )
                      : Text(''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
