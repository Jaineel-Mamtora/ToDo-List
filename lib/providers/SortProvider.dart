import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SortProvider {
  static Future<void> uploadsortByPriority({bool sortByPriority}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (sortByPriority == null) {
      Fluttertoast.showToast(msg: 'Please set Priority!');
    }
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'sortByPriority': sortByPriority});
  }

  static Future<void> uploadsortByDate({bool sortByDate}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (sortByDate == null) {
      Fluttertoast.showToast(msg: 'Please set Title!');
    }
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'sortByDate': sortByDate});
  }
}
