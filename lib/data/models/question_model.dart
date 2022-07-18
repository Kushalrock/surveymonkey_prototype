class QuestionModel {
  final String locationInDatabase;
  final String questionText;
  final String questionType;
  final List<String>? options;
  final String questionPurposeText;

  QuestionModel(this.locationInDatabase, this.questionText, this.questionType,
      this.options, this.questionPurposeText);
}

class AnswerModel {
  final String questionInfo;
  final String answer;

  AnswerModel(this.questionInfo, this.answer);
}
