part of 'question_cubit.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<QuestionModel> questions;

  QuestionLoaded(this.questions);
  @override
  List<Object> get props => [questions];
}

class QuestionGetError extends QuestionState {
  final String error;

  // ignore: prefer_const_constructors_in_immutables
  QuestionGetError(this.error);
  @override
  List<Object> get props => [error];
}
