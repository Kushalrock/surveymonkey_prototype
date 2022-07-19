import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionHistoryAPI {
  final transactionHistory =
      FirebaseFirestore.instance.collection('/transaction-history');
  Future<Map<String, dynamic>?> getTransactionHistory() async {
    final returnList = await transactionHistory
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    return returnList.data();
  }
}
