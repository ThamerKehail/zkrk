import 'package:cloud_firestore/cloud_firestore.dart';

class AzkarModel {
  String? title;
  String? subTitle;
  String? zekr;
  String? aya;
  int? counter;
  int startCounter = 0;

  AzkarModel({
    this.title,
    this.subTitle,
    this.zekr,
    this.aya,
    this.counter,
    required this.startCounter,
  });
  AzkarModel.fromJson(DocumentSnapshot json) {
    final data = json.data() as Map<String, dynamic>;

    title = data['title'];
    subTitle = data['subTitle'];
    zekr = data['zekr'];
    aya = data['aya'];
    counter = data['counter'];
  }
}
