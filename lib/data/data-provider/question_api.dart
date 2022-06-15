import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:surveymonkey_prototype/data/models/question_model.dart';

class QuestionAPI {
  final questionCollection =
      FirebaseFirestore.instance.collection('/questions-group-1');
  final answerCollection = FirebaseFirestore.instance.collection('/user-data');

  final appDataCollection = FirebaseFirestore.instance.collection('/app-data');

  Future<List<Map<String, dynamic>>> getQuestions() async {
    final lastDocRefNameDoc = await appDataCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    var lastDocRefName = "question-group-1-1";
    if (lastDocRefNameDoc.data()!.containsKey("lastTimeOnQuestionGroup")) {
      lastDocRefName = lastDocRefNameDoc.data()!["lastTimeOnQuestionGroup"];
    }
    final lastDocRef = await questionCollection.doc(lastDocRefName).get();

    final returnList =
        await questionCollection.startAtDocument(lastDocRef).limit(5).get();
    final allData = returnList.docs.map((e) => e.data()).toList();
    print(allData);
    return allData;
  }

  Future<void> answerGroupSubmit(Map<String, String> answerList,
      {String questionGroup = "question-group-1-1",
      String profileQuestionGroup = "profiling-questions-1"}) async {
    await answerCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set(answerList, SetOptions(merge: true));
    await appDataCollection.doc(FirebaseAuth.instance.currentUser?.email).set({
      "lastTimeAnswerSubmitted": DateTime.now().toString(),
      "lastTimeOnQuestionGroup": questionGroup,
      "lastTimeOnProfileGroup": profileQuestionGroup
    }, SetOptions(merge: true));
  }
}
