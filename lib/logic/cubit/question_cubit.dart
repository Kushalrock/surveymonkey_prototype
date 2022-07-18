import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surveymonkey_prototype/data/models/question_model.dart';
import 'package:surveymonkey_prototype/data/repositories/question_repository.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final QuestionRepository questionRepository;
  QuestionCubit(this.questionRepository) : super(QuestionLoading());

  Future<void> getQuestionRequested() async {
    emit(QuestionLoading());
    try {
      emit(QuestionLoaded(await questionRepository.getQuestions()));
    } catch (e) {
      emit(QuestionGetError(e.toString()));
      emit(QuestionLoading());
    }
  }

  Future<void> sendAnswersBack(List<AnswerModel> answerModel,
      {String profileQuestionGroup = "profiling-questions-1"}) async {
    await questionRepository.sendAnswersBackToServer(answerModel,
        profileQuestionGroup: profileQuestionGroup);
  }

  Future<void> rouletteTimeSubmit() async {
    try {
      await questionRepository.rouletteTimeSubmit();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> canPlayRoulette() async {
    try {
      bool canPlayRoulette = await questionRepository.canPlayRoulette();
      return canPlayRoulette;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
