import 'package:get/get.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigController extends GetxController {
  var imageUrl = ''.obs;
  var description = ''.obs;
  var audioUrl = ''.obs;

  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void onInit() {
    fetchRemoteConfig();
    super.onInit();
  }

  Future<void> fetchRemoteConfig() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(minutes: 1),
        minimumFetchInterval: Duration.zero,
      ),
    );

    await remoteConfig.fetchAndActivate();

    imageUrl.value = remoteConfig.getString('image_url');
    description.value = remoteConfig.getString('text_description');
    audioUrl.value = remoteConfig.getString('audio_url');
  }
}
