import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../core/viewmodel/qibla_viewmodel.dart';

class QiblaFinderPage extends StatelessWidget {
  final QiblaController controller = Get.put(QiblaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Qibla Finder')),
      body: Center(
        child: Obx(() {
          if (controller.location.value == null) {
            return CircularProgressIndicator();
          }

          double rotationAngle =
              ((controller.qiblaDirection.value - controller.heading.value) *
                  (math.pi / 180) *
                  -1);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Heading: ${controller.heading.value.toStringAsFixed(2)}°'),
              Text(
                'Qibla Direction: ${controller.qiblaDirection.value.toStringAsFixed(2)}°',
              ),
              const SizedBox(height: 40),
              Transform.rotate(
                angle: rotationAngle,
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/84/84649.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Point the arrow toward the Qibla'),
            ],
          );
        }),
      ),
    );
  }
}
