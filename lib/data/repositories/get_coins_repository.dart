import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetCoinsRepository {
  Future<int> getCoins() async {
    final userData = FirebaseFirestore.instance.collection('/app-data');
    int coinsToReturn = 0;
    await userData
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) {
      if (value.exists) {
        if (value.data()!["coins"] != null) {
          print(int.parse(value.data()!["coins"].toString()));
          coinsToReturn = int.parse(value.data()!["coins"].toString());
        }
      }
    });
    return coinsToReturn;
  }
}
