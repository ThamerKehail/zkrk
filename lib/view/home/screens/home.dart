import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/binding.dart';
import 'package:zkrk/helper/color.dart';
import 'package:zkrk/view/athkar/azkar.dart';
import 'package:zkrk/view/home/screens/audio_screen.dart';
import 'package:zkrk/view/prayer/prayer_time.dart';
import 'package:zkrk/view/qibla/qibla.dart';

import '../../../core/viewmodel/home_viewmodel.dart';
import '../../../helper/sliver_appbar_delegate.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://static.vecteezy.com/system/resources/thumbnails/026/186/391/small_2x/time-lapse-of-sunset-sun-sky-skyline-background-video.jpg",
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 0,
                      ), // فوق الصندوق قليلاً
                      child: const Text(
                        'اللهم اكفينا بحلالك عن حرامك',
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
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPrayerTime('الظهر', '11:51'),
                          _buildDateCard('28', 'ابريل'),
                          _buildPrayerTime('الشروق', '05:20'),
                        ],
                      ),
                    ),
                  ),
                ],
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
                          binding: Binding(),
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
                    _buildMenuItem('العداد'),
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
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.start,

                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => AzkarPage());
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
                              "أذكار الصباح ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                            "أذكار الصباح",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 150, width: 400, color: Color(0xFF2F4770)),
                  Container(height: 150, width: 400, color: Color(0xFF2F4770)),
                  Container(height: 150, width: 400, color: Color(0xFF2F4770)),
                  Container(height: 150, width: 400, color: Color(0xFF2F4770)),
                  Container(height: 150, width: 400, color: Color(0xFF2F4770)),
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
    return Column(
      children: [
        Text(prayerName, style: TextStyle(color: Colors.white, fontSize: 16)),
        SizedBox(height: 4),
        Text(time, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildDateCard(String day, String month) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(color: Colors.white, fontSize: 32)),
          Text(month, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}
