import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:surveymonkey_prototype/data/models/question_model.dart';

class QuestionAPI {
  final questionCollection =
      FirebaseFirestore.instance.collection('/questions-group-1');
  final answerCollection = FirebaseFirestore.instance.collection('/user-data');

  Future<List<Map<String, dynamic>>> getQuestions() async {
    final returnList = await questionCollection.get();
    final allData = returnList.docs.map((e) => e.data()).toList();
    print(allData);
    return allData;
  }

  Future<void> answerGroupSubmit(Map<String, String> answerList) async {
    await answerCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set(answerList, SetOptions(merge: true));
  }
}
