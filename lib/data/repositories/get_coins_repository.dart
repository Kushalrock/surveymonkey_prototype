import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surveymonkey_prototype/data/models/cashout_request_model.dart';

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

  Future<void> makeACashoutRequest(
      CashoutRequestModel cashoutRequestModel) async {
    final userData = FirebaseFirestore.instance.collection('/cashout-requests');
    await userData.add(
      {
        "coins": cashoutRequestModel.moneyToBeGiven,
        "paypalAddress": cashoutRequestModel.paypalEmail,
        "officialEmail": cashoutRequestModel.userEmail,
        "DateTime": DateTime.now().toString(),
        "purpose": cashoutRequestModel.purpose
      },
    );
  }
}
