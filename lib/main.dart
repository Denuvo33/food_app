import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/view/navigationView/my_navigationbar.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyBottomNavigation(),
      title: 'Meal Receipt',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: CupertinoColors.activeOrange),
          appBarTheme: AppBarTheme(color: CupertinoColors.activeOrange)),
    );
  }
}
