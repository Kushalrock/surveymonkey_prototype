import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:surveymonkey_prototype/data/models/question_model.dart';

class QuestionAPI {
  final questionCollection =
      FirebaseFirestore.instance.collection('/profiling-questions');
  final answerCollection = FirebaseFirestore.instance.collection('/user-data');

  final appDataCollection = FirebaseFirestore.instance.collection('/app-data');
  final globalAppDataCollection =
      FirebaseFirestore.instance.collection('/global-app-data');

  Future<List<Map<String, dynamic>>> getQuestions() async {
    final appDataCollectionDoc = await appDataCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    final globalAppDataCheck =
        await globalAppDataCollection.doc("question-groups-data").get();

    var lastVisitedDocRefName = "profiling-questions-1";

    // Checking whether it has been time since you have last requested for questions
    if (appDataCollectionDoc.data()!.containsKey("lastTimeAnswerSubmitted")) {
      DateTime lastTimeSubmitted = DateTime.parse(
          appDataCollectionDoc.data()!["lastTimeAnswerSubmitted"]);
      if (!(lastTimeSubmitted.year > DateTime.now().year ||
          lastTimeSubmitted.month > DateTime.now().month ||
          lastTimeSubmitted.day > DateTime.now().day)) {
        throw Exception("Limit Reached");
      }
    }

    // Checking what was the last question you attempted
    if (appDataCollectionDoc.data()!.containsKey("lastTimeOnProfileGroup")) {
      lastVisitedDocRefName =
          appDataCollectionDoc.data()!["lastTimeOnProfileGroup"];
    }

    // Checking whether you are on the lastQuestion
    if (globalAppDataCheck.data()!["profilingquestionlastquestion"] ==
        lastVisitedDocRefName) {
      throw Exception("NoMore");
    }
    final lastDocRef =
        await questionCollection.doc(lastVisitedDocRefName).get();

    final returnList =
        await questionCollection.startAfterDocument(lastDocRef).limit(5).get();
    final allData = returnList.docs.map((e) => e.data()).toList();

    return allData;
  }

  Future<void> answerGroupSubmit(Map<String, String> answerList,
      {String profileQuestionGroup = "profiling-questions-1"}) async {
    await answerCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set(answerList, SetOptions(merge: true));
    await appDataCollection.doc(FirebaseAuth.instance.currentUser?.email).set({
      "lastTimeAnswerSubmitted": DateTime.now().toString(),
      "lastTimeOnProfileGroup": profileQuestionGroup
    }, SetOptions(merge: true));
  }

  Future<void> rouletteTimeSubmit() async {
    await appDataCollection.doc(FirebaseAuth.instance.currentUser?.email).set({
      "lastTimeDailyRoulettePlayed": DateTime.now().toString(),
    }, SetOptions(merge: true));
  }

  Future<bool> canPlayRoulette() async {
    final returnList = await appDataCollection
        .doc(FirebaseAuth.instance.currentUser?.email)
        .get();
    if (returnList.data() == null) {
      return true;
    }
    final returnListDateTimeRouletteData =
        returnList.data()!["lastTimeDailyRoulettePlayed"];
    if (returnListDateTimeRouletteData == null ||
        returnListDateTimeRouletteData == "") {
      return true;
    }

    DateTime lastTimeRoulettePlayed =
        DateTime.parse(returnListDateTimeRouletteData.toString());

    if (lastTimeRoulettePlayed
            .add(const Duration(days: 1))
            .compareTo(DateTime.now()) <=
        0) {
      return true;
    }
    return false;
  }
}
