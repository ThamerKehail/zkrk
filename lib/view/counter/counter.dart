import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zkrk/helper/color.dart';

import '../../core/viewmodel/counter_viewmodel.dart';

class CounterScreen extends StatelessWidget {
  CounterScreen({super.key});
  CounterViewModel counterViewModel = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              counterViewModel.reset();
            },
            icon: Icon(Icons.restart_alt_rounded, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              showDhikrBottomSheet(context);
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
      body: Obx(
        () => PageView.builder(
          onPageChanged: (index) {
            counterViewModel.changeIndex(index);
          },
          itemCount: counterViewModel.azkar.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                counterViewModel.increment(index);
              },
              child: Container(
                color: primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: double.infinity),

                      Text(
                        counterViewModel.azkar[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 70),
                      ),
                      SizedBox(height: 25),
                      ValueListenableBuilder<int>(
                        valueListenable: counterViewModel.counters[index],
                        builder: (context, value, _) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              final position = Tween<Offset>(
                                begin: Offset(0, -.4),
                                end: Offset.zero,
                              ).animate(animation);
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: position,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              value.toString(),
                              key: UniqueKey(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 100,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showDhikrBottomSheet(BuildContext context) {
    final controller = Get.find<CounterViewModel>();

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          // minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => controller.resetAll(),
                ),
                Text(
                  "قائمة الأدعية",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () =>
                          controller.showAddZekr.value
                              ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black26,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Obx(
                                            () => Text(
                                              'اكتب الدعاء هنا',
                                              style: TextStyle(
                                                color:
                                                    controller.isEmpty.value
                                                        ? Colors.grey
                                                        : Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller:
                                                controller.zekrController,
                                            // onChanged:
                                            //     (val) =>
                                            //         controller.checkIfEmpty(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                color: Colors.white38,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            cursorColor: Colors.yellow,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.addZekr(),
                                      child: Container(
                                        height: 35,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                              controller.isEmpty.value
                                                  ? secondPrimaryColor
                                                  : Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 8,
                                        ).copyWith(top: 5),
                                        child: Text(
                                          "اضف الدعاء",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                controller.isEmpty.value
                                                    ? Colors.grey
                                                    : Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox(),
                    ),

                    // ✅ Drag & Swipe Support List
                    Obx(() {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.transparent,
                          // shadowColor: Colors.transparent,
                        ),
                        child: ReorderableListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          onReorder: (oldIndex, newIndex) {
                            if (newIndex > oldIndex) newIndex--;

                            final item = controller.azkar.removeAt(oldIndex);
                            final counter = controller.counters.removeAt(
                              oldIndex,
                            );

                            controller.azkar.insert(newIndex, item);
                            controller.counters.insert(newIndex, counter);
                            controller.saveData(); // ✅ Save after reorder
                          },
                          children: List.generate(controller.azkar.length, (
                            index,
                          ) {
                            final dhikr = controller.azkar[index];
                            final counter = controller.counters[index];
                            final isHighlight =
                                index == controller.currentIndex;

                            return Dismissible(
                              key: ValueKey('$dhikr-$index'),
                              direction: DismissDirection.horizontal,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                color: Colors.orange,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  controller.azkar.removeAt(index);
                                  controller.counters.removeAt(index);
                                  controller.saveData(); // ✅ Save after delete
                                  return true;
                                } else {
                                  final newText = await _showEditDialog(dhikr);
                                  if (newText != null &&
                                      newText.trim().isNotEmpty) {
                                    controller.azkar[index] = newText.trim();
                                    controller.saveData(); // ✅ Save after edit
                                    controller.update();
                                  }
                                  return false;
                                }
                              },
                              child: GestureDetector(
                                onTap: () => controller.increment(index),
                                child: Container(
                                  key: ValueKey(index),
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: secondPrimaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          dhikr,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color:
                                                isHighlight
                                                    ? Colors.yellow
                                                    : Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: counter,
                                        builder: (context, value, _) {
                                          return Text(
                                            '$value',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),

                    SizedBox(height: 12),
                    Text(
                      "يمكنك تحرير أو حذف  من خلال تحريك مكان الدعاء من اليسار إلى اليمين أو العكس.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: controller.total,
                      builder:
                          (context, value, _) => Column(
                            children: [
                              Text(
                                "المجموع",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$value',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FloatingActionButton(
                  backgroundColor: Color(0xFF3DA9FC),
                  onPressed: () => controller.toggleAddZekr(),
                  child: Icon(Icons.playlist_add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<String?> _showEditDialog(String current) async {
    final editController = TextEditingController(text: current);

    return await Get.defaultDialog<String>(
      title: "تعديل الدعاء",
      content: TextField(
        controller: editController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'اكتب الدعاء المعدل',
          border: OutlineInputBorder(),
        ),
      ),
      textConfirm: "حفظ",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: editController.text),
      onCancel: () => Get.back(result: null),
    );
  }
}
