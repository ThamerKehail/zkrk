import 'package:get/get.dart';
import 'package:zkrk/core/viewmodel/home_viewmodel.dart';
import '../core/viewmodel/azkar_viewmodel.dart';
import '../core/viewmodel/counter_viewmodel.dart';
import '../core/viewmodel/prayer_time_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PrayerTimeController(), fenix: true);
    Get.lazyPut(() => CounterViewModel(), fenix: true);
    Get.lazyPut(
      () => AzkarController(),
      fenix: true,
    ); // Use fenix: true to recreate the controller if needed);
  }
}
