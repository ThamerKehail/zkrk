import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../model/prayer_model.dart';

class PrayerTimeController extends GetxController {
  var city = '...'.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  late Timer _timer;
  final remainingTime = ''.obs;
  late DateTime prayerTime;

  var prayerTimes = PrayerModel().obs;

  Rx<String> nextPrayer = ''.obs;
  // // Store the next prayer time
  Rx<String> nextPrayerTime = ''.obs;
  var nextPrayerTimesMap = <String, String>{}.obs;
  var nextPrayerDuration = ''.obs;

  String nowDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  onInit() {
    super.onInit();
    _getUserLocation();
  }

  Map<String, String>? getCurrentPrayerWithFormattedTime() {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('HH:mm');

    final Map<String, String?> times = {
      'Fajr': prayerTimes.value.timings?.fajr,
      'Dhuhr': prayerTimes.value.timings?.dhuhr,
      'Asr': prayerTimes.value.timings?.asr,
      'Maghrib': prayerTimes.value.timings?.maghrib,
      'Isha': prayerTimes.value.timings?.isha,
    };

    final convertedTimes =
        times.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, _convertTimeStringToDateTime(e.value!)))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    for (int i = 0; i < convertedTimes.length; i++) {
      final current = convertedTimes[i];
      final next = i + 1 < convertedTimes.length ? convertedTimes[i + 1] : null;

      if (next != null) {
        if (now.isAfter(current.value) && now.isBefore(next.value)) {
          return {
            convertToArabic(current.key): formatter.format(current.value),
          };
        }
      } else {
        if (now.isAfter(current.value)) {
          return {
            convertToArabic(current.key): formatter.format(current.value),
          };
        }
      }
    }

    return null; // If it's before Fajr
  }

  void startTimer(DateTime targetTime) {
    prayerTime = targetTime;

    _updateRemainingTime();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateRemainingTime();
    });
  }

  String getArabicMonthName() {
    final now = DateTime.now();
    final formatter = DateFormat.MMMM('ar'); // 'MMMM' gives full month name
    return formatter.format(now);
  }

  DateTime _convertTimeStringToDateTime(String time) {
    final now = DateTime.now();
    final parts = time.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final difference = prayerTime.difference(now);

    if (difference.isNegative) {
      remainingTime.value = "Prayer time passed";
      _timer.cancel();
    } else {
      final hours = difference.inHours.toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
      remainingTime.value = "$hours:$minutes:$seconds";
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
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

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      city.value = 'Location service is disabled';
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        city.value = 'Location permission denied';
        return;
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    latitude.value = position.latitude;
    longitude.value = position.longitude;

    // Convert coordinates to city name
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    city.value = placemarks.first.locality ?? 'City not found';

    await getPrayerTimes(latitude.value, longitude.value, nowDate);
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

        startTimer(_convertTimeStringToDateTime(nextPrayerTime.value));

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

        var prayer = await PrayerModel.fromJson(data["data"]);
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
