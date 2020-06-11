import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SortProvider {
  static Future<void> uploadSortByPriority({bool sortByPriority}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (sortByPriority == null) {
      Fluttertoast.showToast(msg: 'Please set Priority!');
    }
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'sortByPriority': sortByPriority});
  }

  static Future<void> uploadSortByDateAscending(
      {bool sortByDateAscending}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (sortByDateAscending == null) {
      Fluttertoast.showToast(msg: 'Please set Date!');
    }
    await Firestore.instance.collection('users').document(user.uid).updateData({
      'sortByDateAscending': sortByDateAscending,
      'sortByDateDescending': false,
    });
  }

  static Future<void> uploadSortByDateDescending(
      {bool sortByDateDescending}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (sortByDateDescending == null) {
      Fluttertoast.showToast(msg: 'Please set Date!');
    }
    await Firestore.instance.collection('users').document(user.uid).updateData({
      'sortByDateDescending': sortByDateDescending,
      'sortByDateAscending': false,
    });
  }
}
