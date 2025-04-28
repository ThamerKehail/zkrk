import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/color.dart';

import '../../core/viewmodel/location_viewmodel.dart';
import '../../core/viewmodel/prayer_time_view_model.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final PrayerTimeController prayerTimeController =
        Get.find<PrayerTimeController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: secondPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Obx(
                      () => Text(
                        locationController.city.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: secondPrimaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          'الاثنين',
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          ),
                        ),
                        Text(
                          'شوال',
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: secondPrimaryColor,
                          ),

                          child: Text(
                            '2025-04-28',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: secondPrimaryColor,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(
                            '1446-10-30',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: secondPrimaryColor,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            '${prayerTimeController.nextPrayer.value} ${prayerTimeController.nextPrayerTime.value} بعد',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Text(
                        //   formatDuration(
                        //     prayerTimeController.nextPrayerDuration.value,
                        //   ),
                        //   style: const TextStyle(
                        //     fontSize: 36,
                        //     color: Colors.yellow,
                        //   ),
                        // ),
                        Text(
                          'Next Prayer in: ${prayerTimeController.nextPrayerDuration.value}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          prayerTile(
                            'الشروق',
                            prayerTimeController.prayerTimes.value.sunrise ??
                                "",
                            'بداية الإشراق: ٥:٤٠',

                            highlight: prayerTimeController.isHighlighted(
                              "الشروق",
                            ),
                          ),
                          prayerTile(
                            'الفجر',
                            prayerTimeController.prayerTimes.value.fajr ?? "",
                            'الإقامة: ٤:٢٢',
                            highlight: prayerTimeController.isHighlighted(
                              "الفجر",
                            ),
                          ),
                          prayerTile(
                            'العصر',
                            prayerTimeController.prayerTimes.value.asr ?? "",
                            'الإقامة: ٣:٣٩',
                            highlight: prayerTimeController.isHighlighted(
                              "العصر",
                            ),
                          ),
                          prayerTile(
                            'الظهر',
                            prayerTimeController.prayerTimes.value.dhuhr ?? "",
                            'الإقامة: ١٢:١١',
                            highlight: prayerTimeController.isHighlighted(
                              "الظهر",
                            ),
                          ),
                          prayerTile(
                            'العشاء',
                            prayerTimeController.prayerTimes.value.isha ?? "",
                            'الإقامة: ٨:١٢',
                            highlight: prayerTimeController.isHighlighted(
                              "العشاء",
                            ),
                          ),
                          prayerTile(
                            'المغرب',
                            prayerTimeController.prayerTimes.value.maghrib ??
                                "",
                            'الإقامة: ٦:٢٧',
                            highlight: prayerTimeController.isHighlighted(
                              "المغرب",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      smallTile(
                        'منتصف الليل',
                        prayerTimeController.prayerTimes.value.midnight ?? "",
                      ),
                      smallTile(
                        'الثلث الأخير',
                        prayerTimeController.prayerTimes.value.lastthird ?? "",
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      extraButton('صلاة الضحى'),
                      extraButton('السنن الرواتب'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: const Color(0xFF1F2D3D),
        //   selectedItemColor: Colors.yellow,
        //   unselectedItemColor: Colors.grey,
        //   showSelectedLabels: false,
        //   showUnselectedLabels: false,
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.refresh), label: ''),
        //     BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: ''),
        //     BottomNavigationBarItem(icon: Icon(Icons.navigation), label: ''),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.calendar_today),
        //       label: '',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.emoji_events),
        //       label: '',
        //     ), // Crown can be replaced
        //   ],
        // ),
      ),
    );
  }

  Widget prayerTile(
    String title,
    String time,
    String subtitle, {
    bool highlight = false,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondPrimaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: highlight ? Colors.yellow : Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget smallTile(String title, String time) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: secondPrimaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget extraButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: secondPrimaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
