// azkar_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/color.dart';
import '../../core/viewmodel/azkar_viewmodel.dart';
import '../../core/viewmodel/prayer_time_view_model.dart';
import '../../model/azkar_model.dart';

class AzkarPage extends StatefulWidget {
  final List<AzkarItem> azkar;
  final String title;

  AzkarPage({super.key, required this.azkar, required this.title});

  @override
  State<AzkarPage> createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  final AzkarController controller = Get.find();
  final PrayerTimeController prayerTimeController = Get.find();

  @override
  void initState() {
    controller.loadAzkar(widget.azkar);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        // actions: [Icon(Icons.arrow_forward_ios, color: Colors.white)],
      ),

      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        color: secondPrimaryColor,

        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                controller.togglePlay(
                  controller.azkar[controller.currentIndex.value].audio,
                );
              },
              icon: Obx(
                () => Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Obx(
                () => Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.grey,
                        strokeWidth: 2,
                        value:
                            (controller
                                .counters[controller.currentIndex.value]
                                ?.value)! /
                            controller
                                .azkar[controller.currentIndex.value]
                                .count,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${controller.counters[controller.currentIndex.value]?.value}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.ios_share, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Obx(
        () =>
            controller.isLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                  onTap: () => controller.pressZekr(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: secondPrimaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          '${prayerTimeController.nextPrayer.value} بعد ${prayerTimeController.remainingTime.value}',
                          style: TextStyle(
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView.builder(
                          controller: controller.pageController,
                          scrollDirection: Axis.horizontal,

                          itemCount: controller.azkar.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   controller.azkar[index].text ?? "",
                                    //   style: TextStyle(
                                    //     color: Colors.blue,
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 25,
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 20),
                                    Text(
                                      controller.azkar[index].text ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),

                                    const SizedBox(height: 20),
                                    Divider(),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: Text(
                                        controller.numberToArabicTimes(
                                          controller.azkar[index].count,
                                        ),

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
                            );
                          },
                          onPageChanged: (index) {
                            controller.changeIndex(index);
                            controller.resetCounter(index + 1);
                            // controller.checkIsCounter();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
