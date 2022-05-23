import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/data/models/question_model.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';
import 'package:surveymonkey_prototype/logic/cubit/question_cubit.dart';
import 'package:surveymonkey_prototype/presentation/components/QuestionScreenComponents/questionlayout.dart';

class QuestionsScreen extends StatefulWidget {
  QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestion = 0;
  List<Map<String, String>> answers = [];
  List<AnswerModel> finalList = [];

  void UpdateQuestionAndSubmitAnswers() {
    setState(() {
      currentQuestion += 1;
    });
    if (currentQuestion > 4) {
      context.read<QuestionCubit>().sendAnswersBack(finalList);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: MediaQuery.of(context).padding,
      color: Colors.lightBlue,
      child: Center(
        child: BlocListener<QuestionCubit, QuestionState>(
          listener: (context, state) {
            if (state is QuestionGetError) {
              Navigator.pop(context);
              print(state.error);
            }
          },
          child: BlocBuilder<QuestionCubit, QuestionState>(
            builder: (context, state) {
              if (state is Loading) {
                return (CircularProgressIndicator(
                  color: Colors.red,
                ));
              } else if (state is QuestionLoaded) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DotsIndicator(
                        dotsCount: 5,
                        position: currentQuestion <= 4
                            ? currentQuestion.toDouble()
                            : 4,
                        decorator: const DotsDecorator(
                          color: Color.fromARGB(
                              255, 101, 101, 101), // Inactive color
                          activeColor: Colors.lightBlue,
                          spacing: EdgeInsets.all(20.0),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Center(
                        child: currentQuestion <= 4
                            ? QuestionLayout(
                                questionText: state
                                    .questions[currentQuestion].questionText,
                                numberOfOptions: state
                                    .questions[currentQuestion].options?.length,
                                options:
                                    state.questions[currentQuestion].options,
                                finalAnswerModel: finalList,
                                questionLoc: state.questions[currentQuestion]
                                    .locationInDatabase,
                                updateQuestion: UpdateQuestionAndSubmitAnswers,
                              )
                            : QuestionLayout(
                                questionText: state.questions[4].questionText,
                                numberOfOptions:
                                    state.questions[4].options?.length,
                                options: state.questions[4].options,
                                finalAnswerModel: finalList,
                                questionLoc:
                                    state.questions[4].locationInDatabase,
                                updateQuestion: UpdateQuestionAndSubmitAnswers,
                              ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            currentQuestion += 1;
                            if (currentQuestion > 4) {
                              context
                                  .read<QuestionCubit>()
                                  .sendAnswersBack(finalList);
                              Navigator.pop(context);
                            }
                          }),
                          child: const Text("Skip Question"),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    ));
  }
}
