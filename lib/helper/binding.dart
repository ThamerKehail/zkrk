import 'package:get/get.dart';
import 'package:zkrk/core/viewmodel/home_viewmodel.dart';

import '../core/viewmodel/location_viewmodel.dart';
import '../core/viewmodel/prayer_time_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => PrayerTimeController());
  }
}
