import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/color.dart';

class CounterViewModel extends GetxController {
  RxList<String> azkar = <String>[].obs;
  List<ValueNotifier<int>> counters = [];
  RxInt currentIndex = 0.obs;
  ValueNotifier<int> total = ValueNotifier<int>(0);

  RxBool showAddZekr = false.obs;
  RxBool isEmpty = true.obs;
  TextEditingController zekrController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    zekrController.addListener(() {
      isEmpty.value = zekrController.text.trim().isEmpty;
    });
    loadData();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void toggleAddZekr() {
    showAddZekr.value = !showAddZekr.value;
  }

  void increment(int index) {
    counters[index].value++;
    updateTotal();
    saveData();
  }

  void reset() {
    Get.defaultDialog(
      backgroundColor: secondPrimaryColor,
      title: "تصفير العداد",
      titleStyle: TextStyle(color: Colors.white),
      middleText:
          "سيتم تصفير عداد هذا الذكر فقط\nهل انت متأكد من تصفير العداد؟",
      middleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      confirm: ElevatedButton(
        onPressed: () {
          counters[currentIndex.value].value = 0;
          updateTotal();
          saveData();

          Get.back(); // Close the dialog
        },
        child: Text("نعم", style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(
        onPressed: () {
          Get.back(); // Just close dialog
        },
        child: Text("إلغاء", style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  void resetAll() {
    Get.defaultDialog(
      backgroundColor: secondPrimaryColor,
      title: "تصفير كل العدادات",
      titleStyle: TextStyle(color: Colors.white),
      middleText: "هل انت متأكد من انك تريد تصفير العداد لجميع الاذكار ؟",
      middleTextStyle: TextStyle(color: Colors.white, fontSize: 16),

      confirm: ElevatedButton(
        onPressed: () {
          for (var counter in counters) {
            counter.value = 0;
          }
          updateTotal();
          saveData();
          Get.back();
        },
        child: Text("نعم", style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: Text("إلغاء", style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  void addZekr() {
    final text = zekrController.text.trim();
    if (text.isEmpty) return;

    azkar.add(text);
    counters.add(ValueNotifier<int>(0));
    zekrController.clear();
    isEmpty.value = true;
    updateTotal();
    saveData();
    toggleAddZekr();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('azkar', azkar.toList());
    await prefs.setString(
      'counters',
      jsonEncode(counters.map((c) => c.value).toList()),
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔒 Fix: safely load azkar
    List<String> loadedAzkar = [];

    final stringList = prefs.getStringList('azkar');
    if (stringList != null) {
      loadedAzkar = stringList;
    } else {
      // Maybe it was saved as a JSON string by mistake
      final jsonString = prefs.getString('azkar');
      if (jsonString != null) {
        try {
          final List<dynamic> decoded = jsonDecode(jsonString);
          loadedAzkar = List<String>.from(decoded);
        } catch (e) {
          // fallback
          loadedAzkar = [];
        }
      }
    }

    azkar.assignAll(loadedAzkar);

    // 🔒 Fix: safely load counters
    final savedCountersString = prefs.getString('counters');
    if (savedCountersString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedCountersString);
        counters =
            decoded.map((value) => ValueNotifier<int>(value ?? 0)).toList();
      } catch (e) {
        counters = List.generate(azkar.length, (_) => ValueNotifier<int>(0));
      }
    } else {
      counters = List.generate(azkar.length, (_) => ValueNotifier<int>(0));
    }

    // default if no azkar found
    if (azkar.isEmpty) {
      azkar.addAll(['سبحان الله', 'الحمد لله', 'الله أكبر']);
      counters = List.generate(azkar.length, (_) => ValueNotifier<int>(0));
    }

    updateTotal();
  }

  void updateTotal() {
    total.value = counters.fold(0, (sum, e) => sum + e.value);
  }
}
