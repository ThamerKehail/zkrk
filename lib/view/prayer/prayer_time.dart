import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/color.dart';
import 'package:zkrk/view/prayer/widgets/extra_button.dart';
import 'package:zkrk/view/prayer/widgets/prayer_tile.dart';
import 'package:zkrk/view/prayer/widgets/small_tile.dart';
import '../../core/viewmodel/prayer_time_view_model.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PrayerTimeController prayerTimeController =
        Get.find<PrayerTimeController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Obx(
          () =>
              (prayerTimeController.prayerTimes.value.timings == null ||
                      prayerTimeController.nextPrayer.value.isEmpty)
                  ? Center(child: CircularProgressIndicator())
                  : SafeArea(
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
                                  prayerTimeController.city.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    prayerTimeController
                                            .prayerTimes
                                            .value
                                            .date
                                            ?.hijri
                                            ?.weekday
                                            ?.ar ??
                                        "",
                                    style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontFamily: 'Amiri',
                                    ),
                                  ),
                                  Text(
                                    prayerTimeController
                                            .prayerTimes
                                            .value
                                            .date
                                            ?.hijri
                                            ?.month
                                            ?.ar ??
                                        "",
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
                                      prayerTimeController.nowDate,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
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
                                      prayerTimeController
                                              .prayerTimes
                                              .value
                                              .date
                                              ?.hijri
                                              ?.date ??
                                          "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
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

                                  Obx(
                                    () => Text(
                                      prayerTimeController.remainingTime.value,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    PrayerTile(
                                      highlight: prayerTimeController
                                          .isHighlighted("الشروق"),
                                      title: 'الشروق',
                                      time:
                                          prayerTimeController
                                              .prayerTimes
                                              .value
                                              .timings
                                              ?.sunrise ??
                                          "",
                                      subtitle: 'بداية الإشراق: ٥:٤٠',
                                    ),
                                    PrayerTile(
                                      highlight: prayerTimeController
                                          .isHighlighted("الفجر"),
                                      title: 'الفجر',
                                      time:
                                          prayerTimeController
                                              .prayerTimes
                                              .value
                                              .timings
                                              ?.fajr ??
                                          "",
                                      subtitle: 'الإقامة: ٤:٢٢',
                                    ),
                                    PrayerTile(
                                      title: 'العصر',
                                      time:
                                          prayerTimeController
                                              .prayerTimes
                                              .value
                                              .timings
                                              ?.asr ??
                                          "",
                                      subtitle: 'الإقامة: ٣:٣٩',
                                      highlight: prayerTimeController
                                          .isHighlighted("العصر"),
                                    ),
                                    PrayerTile(
                                      title: 'الظهر',
                                      time:
                                          prayerTimeController
                                              .prayerTimes
                                              .value
                                              .timings
                                              ?.dhuhr ??
                                          "",
                                      subtitle: 'الإقامة: ١٢:١١',
                                      highlight: prayerTimeController
                                          .isHighlighted("الظهر"),
                                    ),
                                    PrayerTile(
                                      title: 'العشاء',
                                      time:
                                          prayerTimeController
                                              .prayerTimes
                                              .value
                                              .timings
                                              ?.isha ??
                                          "",
                                      subtitle: 'الإقامة: ٨:١٢',
                                      highlight: prayerTimeController
                                          .isHighlighted("العشاء"),
                                    ),
                                    PrayerTile(
                                      title: 'المغرب',
                                      time:
                                          prayerTimeController
                                              .prayerTimes
                                              .value
                                              .timings
                                              ?.maghrib ??
                                          "",
                                      subtitle: 'الإقامة: ٦:٢٧',
                                      highlight: prayerTimeController
                                          .isHighlighted("المغرب"),
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
                                SmallTile(
                                  title: 'منتصف الليل',
                                  time:
                                      prayerTimeController
                                          .prayerTimes
                                          .value
                                          .timings
                                          ?.midnight ??
                                      "",
                                ),
                                SmallTile(
                                  title: 'الثلث الأخير',
                                  time:
                                      prayerTimeController
                                          .prayerTimes
                                          .value
                                          .timings
                                          ?.lastthird ??
                                      "",
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ExtraButton(text: 'صلاة الضحى'),
                                ExtraButton(text: 'السنن الرواتب'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
