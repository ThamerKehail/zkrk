// azkar_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/color.dart';
import '../../core/viewmodel/azkar_viewmodel.dart';

class AzkarPage extends StatelessWidget {
  final AzkarController controller = Get.find();

  AzkarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "أذكار الصباح",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        // actions: [Icon(Icons.arrow_forward_ios, color: Colors.white)],
      ),
      bottomNavigationBar: Obx(
        () =>
            controller.isCounter.value
                ? Container(
                  height: 100,
                  width: double.infinity,
                  color: secondPrimaryColor,
                  child: Center(
                    child: GestureDetector(
                      onTap:
                          controller.isDone(controller.currentIndex)
                              ? null
                              : () => controller.incrementCounter(
                                controller.currentIndex,
                              ),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            '${controller.counters[controller.currentIndex]?.value}',
                            style: TextStyle(color: Colors.grey, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : SizedBox(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: secondPrimaryColor,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "العصر بعد 1:58:16",
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
              scrollDirection: Axis.horizontal,

              itemCount: controller.azkar.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.azkar[index].title ?? "",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.azkar[index].zekr ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        controller.azkar[index].subTitle ?? "",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.azkar[index].aya ?? "",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          "ثلاث مرات",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onPageChanged: (index) {
                controller.changeIndex(index);
                controller.resetCounter();
                controller.checkIsCounter();
              },
            ),
          ),
        ],
      ),
    );
  }
}
