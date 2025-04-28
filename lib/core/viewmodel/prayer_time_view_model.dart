import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../model/prayer_model.dart';
import 'location_viewmodel.dart';

class PrayerTimeController extends GetxController {
  late LocationController locationController;
  late double latitude;
  late double longitude;

  PrayerTimeController() {
    locationController = Get.find<LocationController>();
    latitude = locationController.latitude.value;
    longitude = locationController.longitude.value;
  }
  var prayerTimes = PrayerModel().obs;

  Rx<String> nextPrayer = ''.obs;
  // // Store the next prayer time
  Rx<String> nextPrayerTime = ''.obs;
  var nextPrayerTimesMap = <String, String>{}.obs;
  var nextPrayerDuration = ''.obs;

  @override
  onInit() {
    super.onInit();
    getPrayerTimes(24.807290, 46.617737, "28-04-2025");
  }
  // Store the prayer times

  // Fetch prayer times from the API based on latitude and longitude

  bool isHighlighted(String prayerName) {
    // Check if the prayer name matches the next prayer
    return nextPrayer.value == (prayerName);
  }

  void calculateNextPrayerDuration() {
    DateTime now = DateTime.now(); // Current time
    DateFormat format = DateFormat('HH:mm'); // Time format (24-hour)

    // Find the next prayer time
    for (var prayer in nextPrayerTimesMap.entries) {
      String prayerTimeString = prayer.value;
      DateTime prayerTime = format.parse(
        '${now.year}-${now.month}-${now.day} $prayerTimeString',
      );

      if (prayerTime.isAfter(now)) {
        Duration duration = prayerTime.difference(now); // Get the duration
        nextPrayerDuration.value =
            '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
        break; // Exit after calculating the first upcoming prayer time
      }
    }
  }

  Future<void> getNextPrayer(
    double latitude,
    double longitude,
    String date,
  ) async {
    final url =
        'https://api.aladhan.com/v1/nextPrayer/$date?latitude=$latitude&longitude=$longitude';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print(date);

        final timings = data['data']['timings'];
        nextPrayerTimesMap.value = Map<String, String>.from(timings);
        nextPrayer.value = nextPrayerTimesMap.keys.first;
        nextPrayer.value = convertToArabic(nextPrayer.value);
        nextPrayerTime.value = nextPrayerTimesMap.values.first;
        print("nextPrayer=======$nextPrayer");

        // Parsing the prayer times from the response
        // prayerTimes.value = prayer;
      } else {}
    } catch (e) {
      // prayerTimes.value = {'error': 'Failed to fetch prayer times'};
    }
  }

  Future<void> getPrayerTimes(
    double latitude,
    double longitude,
    String date,
  ) async {
    final url =
        'https://api.aladhan.com/v1/timings/$date?latitude=$latitude&longitude=$longitude';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print(date);

        var prayer = await PrayerModel.fromJson(data["data"]["timings"]);
        // print("prayer=======$prayer");

        // Parsing the prayer times from the response
        prayerTimes.value = prayer;
        await getNextPrayer(latitude, longitude, date);
      } else {}
    } catch (e) {
      // prayerTimes.value = {'error': 'Failed to fetch prayer times'};
    }
  }

  String convertToArabic(String text) {
    // Mapping English prayer times to Arabic
    final Map<String, String> englishToArabic = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    // Check if the text exists in the map and return the Arabic equivalent
    return englishToArabic[text] ??
        text; // Return the original text if no translation exists
  }
}
