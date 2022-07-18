import 'package:surveymonkey_prototype/data/data-provider/question_api.dart';

import '../models/question_model.dart';

class QuestionRepository {
  final QuestionAPI questionAPI = QuestionAPI();

  Future<List<QuestionModel>> getQuestions() async {
    try {
      final rawQuestions = await questionAPI.getQuestions();
      return castToQuestionModel(rawQuestions);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  List<QuestionModel> castToQuestionModel(
      List<Map<String, dynamic>> questionList) {
    List<QuestionModel> returnList = [];
    for (var question in questionList) {
      returnList.add(QuestionModel(
        question['question-loc'],
        question['question-text'],
        question['question-type'],
        question['options'].toString().split(",").toList(),
        question['question-info'],
      ));
    }
    return returnList;
  }

  Future<void> sendAnswersBackToServer(List<AnswerModel> answerModelList,
      {String profileQuestionGroup = "profiling-questions-1"}) async {
    try {
      var result = {
        for (AnswerModel answerModel in answerModelList)
          answerModel.questionInfo: answerModel.answer
      };
      await questionAPI.answerGroupSubmit(result,
          profileQuestionGroup: profileQuestionGroup);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> rouletteTimeSubmit() async {
    try {
      await questionAPI.rouletteTimeSubmit();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> canPlayRoulette() async {
    try {
      bool canPlayRoulette = await questionAPI.canPlayRoulette();
      return canPlayRoulette;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
