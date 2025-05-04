import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/binding.dart';
import 'package:zkrk/helper/color.dart';
import 'package:zkrk/view/athkar/azkar.dart';
import 'package:zkrk/view/home/screens/audio_screen.dart';
import 'package:zkrk/view/prayer/prayer_time.dart';
import 'package:zkrk/view/qibla/qibla.dart';

import '../../../core/viewmodel/home_viewmodel.dart';
import '../../../core/viewmodel/prayer_time_view_model.dart';
import '../../../core/viewmodel/remote_config_viewmodel.dart';
import '../../../helper/sliver_appbar_delegate.dart';
import '../../counter/counter.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});
  final PrayerTimeController prayerTimeController = Get.put(
    PrayerTimeController(),
  );
  final remoteConfigController = Get.put(RemoteConfigController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            backgroundColor: primaryColor,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Obx(
                () =>
                    controller.showTitle.value
                        ? Text(
                          'ذكرك',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : SizedBox(),
              ),
              background: Obx(
                () => Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      remoteConfigController.imageUrl.value,
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withOpacity(0.3)),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 0,
                        ), // فوق الصندوق قليلاً
                        child: Text(
                          remoteConfigController.description.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black45,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0, // يلصقه أسفل الصورة
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        child: Obx(
                          () => Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildPrayerTime(
                                prayerTimeController
                                        .getCurrentPrayerWithFormattedTime()
                                        ?.keys
                                        .first ??
                                    "",
                                prayerTimeController
                                        .getCurrentPrayerWithFormattedTime()
                                        ?.values
                                        .first
                                        .toString() ??
                                    "",
                              ),
                              _buildDateCard(
                                prayerTimeController
                                        .prayerTimes
                                        .value
                                        .date
                                        ?.gregorian
                                        ?.day ??
                                    "",
                                prayerTimeController.getArabicMonthName(),
                              ),
                              _buildPrayerTime(
                                prayerTimeController.nextPrayer.value,
                                prayerTimeController.nextPrayerTime.value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            leading: IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.white),
              onPressed: () {
                Get.to(() => AudioScreen());
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {},
              ),
              SizedBox(width: 8),
            ],
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              child: Container(
                color: secondPrimaryColor,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuItem('المنوعة'),
                    _buildMenuItem(
                      'الصلاة',
                      onTap: () {
                        Get.to(
                          () => PrayerTimesScreen(),

                          preventDuplicates: true,
                        );
                      },
                    ),
                    _buildMenuItem(
                      'القبلة',
                      onTap: () {
                        Get.to(() => QiblaFinderPage());
                      },
                    ),
                    _buildMenuItem('المفضلة'),
                    _buildMenuItem(
                      'العداد',
                      onTap: () => Get.to(CounterScreen()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.start,

                        children: List.generate(controller.azkar.length, (
                          index,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => AzkarPage(
                                  azkar: controller.azkar[index].array,
                                  title: controller.azkar[index].category,
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: secondPrimaryColor,
                                  width: 3,
                                ),
                              ),
                              child: Text(
                                controller.azkar[index].category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildPrayerTime(String prayerName, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Text(prayerName, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(width: 4),
          Text(time, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDateCard(String day, String month) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(month, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}
