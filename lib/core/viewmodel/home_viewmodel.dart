import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../model/azkar_model.dart';

class HomeController extends GetxController {
  late ScrollController scrollController;
  var showTitle = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    loadAzkarFromAssets();
  }

  var azkar = <AzkarModel>[].obs;

  Future<void> loadAzkarFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/athkar.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    print(jsonData);
    var data = jsonData.map((json) => AzkarModel.fromJson(json)).toList();

    azkar.addAll(data);
    print(azkar.length);
  }

  void _scrollListener() {
    if (scrollController.hasClients) {
      if (scrollController.offset > 150 && !showTitle.value) {
        showTitle.value = true;
      } else if (scrollController.offset <= 150 && showTitle.value) {
        showTitle.value = false;
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
