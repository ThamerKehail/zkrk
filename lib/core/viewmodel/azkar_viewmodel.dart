// azkar_controller.dart
import 'package:get/get.dart';
import 'package:zkrk/core/services/azkar_service.dart';
import 'package:zkrk/model/azkar_model.dart';

class AzkarController extends GetxController {
  RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  var azkar = <AzkarModel>[].obs;

  RxInt counter = 0.obs;
  var counters = <RxInt?>[].obs;

  int currentIndex = 0;

  changeIndex(int index) {
    currentIndex = index;
  }

  RxBool isCounter = false.obs;

  checkIsCounter() {
    isCounter.value = counters[currentIndex] != null;
  }

  addCounter() {
    int limit = azkar[currentIndex].counter ?? 0;
    int x = azkar[currentIndex].startCounter ?? 1;
    print("x: $x");
    print("limit: $limit");
    azkar[currentIndex].startCounter++;
    if (x < limit) {
      x++;
    } else {
      Get.snackbar("Limit Reached", "You have reached the limit of $limit");
    }
  }

  resetCounter() {
    counter.value = 0;
  }

  @override
  onInit() {
    super.onInit();
    _getAzkar();
  }

  void incrementCounter(int index) {
    print("object");
    final counter = counters[index];
    final max = azkar[index].counter;
    print(counter);
    if (counter != null && max != null && counter.value < max) {
      counter.value++;
    }
  }

  bool isDone(int index) {
    final counter = counters[index];
    final max = azkar[index].counter;
    return counter != null && max != null && counter.value >= max;
  }

  _getAzkar() async {
    _isLoading.value = true;
    await AzkarServices().getAzkar().then((data) {
      for (var element in data) {
        AzkarModel azkarModel = AzkarModel.fromJson(element);
        azkar.add(azkarModel);
      }
      counters.value =
          azkar.map((e) => e.counter != null ? 0.obs : null).toList();

      update();
      print(azkar);
      checkIsCounter();
    });
    _isLoading.value = false;
  }
}
