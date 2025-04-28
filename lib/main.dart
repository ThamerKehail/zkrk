import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/color.dart';
import 'package:zkrk/view/home/screens/home.dart';

import 'helper/binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('ar', 'SA'),
      initialBinding: Binding(),
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}
