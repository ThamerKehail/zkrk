import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zkrk/model/azkar_model.dart';

class AzkarController extends GetxController {
  RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;
  PageController pageController = PageController();

  void nextPage() {
    if (currentIndex.value < azkar.length - 1) {
      // Replace 4 with your page count - 1
      currentIndex.value++;
      pageController.animateToPage(
        currentIndex.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;

  Future<void> togglePlay(String path) async {
    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(path));
    }
    isPlaying.value = !isPlaying.value;
  }

  pressZekr() {
    if (isDone(currentIndex.value)) {
      // nextPage();
    } else {
      incrementCounter(currentIndex.value);
    }
  }

  var azkar = <AzkarItem>[].obs;
  String numberToArabicTimes(int number) {
    if (number < 1 || number > 100) return '';

    final units = [
      '',
      'واحدة',
      'اثنتان',
      'ثلاث',
      'أربع',
      'خمس',
      'ست',
      'سبع',
      'ثمان',
      'تسع',
    ];

    final tens = [
      '',
      'عشر',
      'عشرون',
      'ثلاثون',
      'أربعون',
      'خمسون',
      'ستون',
      'سبعون',
      'ثمانون',
      'تسعون',
      'مئة',
    ];

    if (number == 1) return 'مرة';
    if (number == 2) return 'مرتان';
    if (number >= 3 && number <= 9) {
      return '${units[number]} مرات';
    }
    if (number == 10) return 'عشر مرات';

    if (number > 10 && number < 100) {
      int unit = number % 10;
      int ten = number ~/ 10;

      if (unit == 0) {
        return '${tens[ten]} مرة';
      } else {
        return '${units[unit]} و${tens[ten]} مرة';
      }
    }

    if (number == 100) return 'مئة مرة';

    return '';
  }

  loadAzkar(List<AzkarItem> azkar) async {
    this.azkar.value = azkar;
    counters.value = azkar.map((e) => 0.obs).toList();
  }

  RxInt counter = 0.obs;
  var counters = <RxInt?>[].obs;

  RxInt currentIndex = 0.obs;

  changeIndex(int index) {
    currentIndex.value = index;
  }

  RxBool isCounter = false.obs;

  resetCounter(int index) {
    counter.value = 0;
    counters[index]?.value = 0;
  }

  @override
  onInit() {
    super.onInit();
    _audioPlayer.onPlayerComplete.listen((event) {
      print("✅ Audio finished playing");

      // Example: go to next zekr automatically
      if (isDone(currentIndex.value)) {
        nextPage();
      }
    });
    // _getAzkar();
    // loadAzkarFromAssets();
  }

  @override
  onClose() {
    _audioPlayer.dispose();
  }

  Future<void> loadAzkarFromAssets() async {
    final String jsonString = await rootBundle.loadString('assets/athkar.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    print(jsonData);
    var data = jsonData.map((json) => AzkarModel.fromJson(json)).toList();
    azkar.value = data[0].array;
    counters.value = azkar.map((e) => e.count != null ? 0.obs : null).toList();
  }

  void incrementCounter(int index) {
    print("object");
    final counter = counters[index];
    final max = azkar[index].count;
    print(counter);
    if (counter != null && counter.value < max) {
      counter.value++;
    }
    if (counter!.value == max) {
      nextPage();
    }
  }

  bool isDone(int index) {
    final counter = counters[index];
    final max = azkar[index].count;
    return counter != null && counter.value >= max;
  }
}
