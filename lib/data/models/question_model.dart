class QuestionModel {
  final String locationInDatabase;
  final String questionText;
  final String questionType;
  final List<String>? options;

  QuestionModel(this.locationInDatabase, this.questionText, this.questionType,
      this.options);
}

class AnswerModel {
  final String questionLocation;
  final String answer;

  AnswerModel(this.questionLocation, this.answer);
}
