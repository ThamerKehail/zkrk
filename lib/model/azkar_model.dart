import 'package:cloud_firestore/cloud_firestore.dart';

class AzkarModel {
  final int id;
  final String category;
  final String audio;
  final String filename;
  final List<AzkarItem> array;

  AzkarModel({
    required this.id,
    required this.category,
    required this.audio,
    required this.filename,
    required this.array,
  });
  factory AzkarModel.fromJson(Map<String, dynamic> json) {
    return AzkarModel(
      id: json['id'],
      category: json['category'],
      audio: json['audio'],
      filename: json['filename'],
      array:
          (json['array'] as List)
              .map((item) => AzkarItem.fromJson(item))
              .toList(),
    );
  }
}

class AzkarItem {
  final int id;
  final String text;
  final int count;
  int startCounter;
  final String audio;
  final String filename;

  AzkarItem({
    required this.id,
    required this.text,
    required this.count,
    required this.audio,
    required this.filename,
    this.startCounter = 0,
  });

  factory AzkarItem.fromJson(Map<String, dynamic> json) {
    return AzkarItem(
      id: json['id'],
      text: json['text'],
      count: json['count'],
      audio: json['audio'],
      filename: json['filename'],
    );
  }
}
