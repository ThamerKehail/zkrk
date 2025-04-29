import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;

class QiblaController extends GetxController {
  var heading = 0.0.obs;
  var qiblaDirection = 0.0.obs;
  var location = Rxn<Position>();

  final double kaabaLat = 21.4225;
  final double kaabaLng = 39.8262;

  @override
  void onInit() {
    super.onInit();
    getLocation();
    listenToCompass();
  }

  void getLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    location.value = pos;
    calculateQiblaDirection(pos.latitude, pos.longitude);
  }

  void calculateQiblaDirection(double lat, double lon) {
    final userLocation = vector.Vector2(lat, lon);
    final kaabaLocation = vector.Vector2(kaabaLat, kaabaLng);

    final deltaLon = vector.radians(kaabaLocation.y - userLocation.y);
    final lat1 = vector.radians(userLocation.x);
    final lat2 = vector.radians(kaabaLocation.x);

    final x = math.sin(deltaLon);
    final y =
        math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(deltaLon);
    final bearing = vector.degrees(math.atan2(x, y));
    qiblaDirection.value = (bearing + 360) % 360;
  }

  void listenToCompass() {
    FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        heading.value = event.heading!;
      }
    });
  }
}
