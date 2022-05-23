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
          question['options'].toString().split(",").toList()));
    }
    return returnList;
  }

  Future<void> sendAnswersBackToServer(
      List<AnswerModel> answerModelList) async {
    try {
      var result = {
        for (AnswerModel answerModel in answerModelList)
          answerModel.questionLocation: answerModel.answer
      };
      await questionAPI.answerGroupSubmit(result);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
