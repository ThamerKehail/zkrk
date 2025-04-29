import 'package:cloud_firestore/cloud_firestore.dart';

class AzkarServices {
  final CollectionReference _morningCollection = FirebaseFirestore.instance
      .collection("azkar")
      .doc("categories")
      .collection("morning");

  Future<List<QueryDocumentSnapshot>> getAzkar() async {
    var data = await _morningCollection.get();
    return data.docs;
  }
}
