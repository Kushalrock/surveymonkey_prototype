import 'package:flutter/material.dart';
import 'package:surveymonkey_prototype/data/models/question_model.dart';

class QuestionLayout extends StatelessWidget {
  final String questionText;
  final int? numberOfOptions;
  final List<String>? options;
  final List<AnswerModel> finalAnswerModel;
  final String questionLoc;
  final updateQuestion;
  const QuestionLayout(
      {Key? key,
      required this.questionText,
      required this.numberOfOptions,
      required this.options,
      required this.finalAnswerModel,
      required this.questionLoc,
      this.updateQuestion})
      : super(key: key);

  void addDataToAnswerList(String questionLoc, String answer) {
    print(answer + "The Answer");
    finalAnswerModel.add(AnswerModel(questionLoc, answer));
    updateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              questionText,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          numberOfOptions! > 2
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: OutlinedButton(
                            onPressed: () {
                              addDataToAnswerList(questionLoc, options![0]);
                            },
                            child: Text(options![0]),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: OutlinedButton(
                            onPressed: () {
                              addDataToAnswerList(questionLoc, options![1]);
                            },
                            child: Text(options![1]),
                          ),
                        ),
                      ],
                    ),
                    numberOfOptions! <= 3
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: OutlinedButton(
                              onPressed: () {
                                addDataToAnswerList(questionLoc, options![2]);
                              },
                              child: Text(
                                options![2],
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: OutlinedButton(
                                  onPressed: () {
                                    addDataToAnswerList(
                                        questionLoc, options![2]);
                                  },
                                  child: Text(options![2]),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: OutlinedButton(
                                  onPressed: () {
                                    addDataToAnswerList(
                                        questionLoc, options![3]);
                                  },
                                  child: Text(options![3]),
                                ),
                              ),
                            ],
                          ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: OutlinedButton(
                        onPressed: () {
                          addDataToAnswerList(questionLoc, options![0]);
                        },
                        child: Text(options![0]),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: OutlinedButton(
                        onPressed: () {
                          addDataToAnswerList(questionLoc, options![1]);
                        },
                        child: Text(options![1]),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
