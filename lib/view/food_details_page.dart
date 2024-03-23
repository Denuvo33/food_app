import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:food_app/controller/favorite_controller.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class FoodDetailsPage extends StatefulWidget {
  String? id, name, image, category, area, tags, instruction;
  int? tableId;
  RxBool isLiked = false.obs;

  FoodDetailsPage(
      {super.key,
      required this.area,
      required this.category,
      required this.tableId,
      required this.id,
      required this.image,
      required this.instruction,
      required this.name,
      required this.isLiked,
      required this.tags});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FavoriteController>();
    var newTags = widget.tags?.replaceAll(',', ' ').split(' ').toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 200,
                    width: 160,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.image!,
                        errorWidget: (context, url, error) {
                          return Icon(Icons.image_not_supported);
                        },
                        placeholder: (context, url) {
                          return SizedBox(
                            height: 180,
                            width: 120,
                            child: Shimmer.fromColors(
                                child: Card(),
                                baseColor: Colors.white,
                                highlightColor: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      widget.name!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (widget.isLiked.value) {
                          Future.delayed(Duration.zero, () {
                            Get.defaultDialog(
                                middleText:
                                    'Are you sure want to remove this food from your favorite page?',
                                onConfirm: () {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    widget.isLiked(false);
                                    controller.delete(widget.tableId!);
                                    setState(() {});
                                    Navigator.pop(context);
                                  });
                                },
                                textCancel: 'No',
                                textConfirm: 'Yes');
                          });
                        } else {
                          widget.isLiked(true);
                          controller.saveFood({
                            'strMeal': widget.name,
                            'strMealThumb': widget.image,
                            'strTags': widget.tags ?? '',
                            'strArea': widget.area ?? '',
                            'strCategory': widget.category ?? '',
                            'created_at': DateTime.now().toString(),
                            'strInstructions': widget.instruction,
                          });
                          Get.snackbar(widget.name!, 'Succes add to favorite',
                              snackPosition: SnackPosition.BOTTOM);
                          setState(() {});
                        }
                      },
                      icon: widget.isLiked.value
                          ? Icon(
                              Icons.favorite,
                              size: 40,
                              color: CupertinoColors.activeOrange,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 40,
                            )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text('Category: ${widget.category}'),
              SizedBox(
                height: 5,
              ),
              Text('Area: ${widget.area}'),
              SizedBox(
                height: 5,
              ),
              Visibility(
                visible: widget.tags != '',
                replacement: Text(''),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newTags?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.deepOrange, width: 2),
                          ),
                          child: Center(child: Text(newTags![index])));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Instruction',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.instruction!,
              )
            ],
          ),
        ),
      ),
    );
  }
}
