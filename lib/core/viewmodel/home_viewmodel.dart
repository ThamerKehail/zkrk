import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late ScrollController scrollController;
  var showTitle = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
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
