import 'package:flutter/material.dart';
import 'package:surveymonkey_prototype/data/models/question_model.dart';

class QuestionLayout extends StatefulWidget {
  final String questionText;
  final int? numberOfOptions;
  final List<String>? options;
  final List<AnswerModel> finalAnswerModel;
  final String questionLoc;
  final updateQuestion;
  final String questionType;
  const QuestionLayout(
      {Key? key,
      required this.questionText,
      required this.numberOfOptions,
      required this.options,
      required this.finalAnswerModel,
      required this.questionLoc,
      this.updateQuestion,
      this.questionType = "options"})
      : super(key: key);

  @override
  State<QuestionLayout> createState() => _QuestionLayoutState();
}

class _QuestionLayoutState extends State<QuestionLayout> {
  void addDataToAnswerList(String questionLoc, String answer) {
    print(answer + "The Answer");
    widget.finalAnswerModel.add(AnswerModel(questionLoc, answer));
    widget.updateQuestion();
  }

  final TextEditingController inputField = TextEditingController();
  String dropDownVal = "--";

  Widget getDropDownWidget() {
    if (widget.questionType == "dropdown") {
      return Column(
        children: [
          DropdownButton(
              items: widget.options
                  ?.map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (String? newVal) {
                setState(() {
                  dropDownVal = newVal.toString();
                });
              }),
          OutlinedButton(
            onPressed: () {
              addDataToAnswerList(widget.questionLoc, dropDownVal);
            },
            child: const Text("Next Question"),
          ),
        ],
      );
    }
    return const SizedBox(
      height: 0,
    );
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
              widget.questionText,
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
          if (widget.questionType == "options")
            widget.numberOfOptions! > 2
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: OutlinedButton(
                              onPressed: () {
                                addDataToAnswerList(
                                    widget.questionLoc, widget.options![0]);
                              },
                              child: Text(widget.options![0]),
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
                                    widget.questionLoc, widget.options![1]);
                              },
                              child: Text(
                                widget.options![1],
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.numberOfOptions! <= 3
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: OutlinedButton(
                                onPressed: () {
                                  addDataToAnswerList(
                                      widget.questionLoc, widget.options![2]);
                                },
                                child: Text(
                                  widget.options![2],
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      addDataToAnswerList(widget.questionLoc,
                                          widget.options![2]);
                                    },
                                    child: Text(widget.options![2]),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      addDataToAnswerList(widget.questionLoc,
                                          widget.options![3]);
                                    },
                                    child: Text(widget.options![3]),
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
                            addDataToAnswerList(
                                widget.questionLoc, widget.options![0]);
                          },
                          child: Text(widget.options![0]),
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
                                widget.questionLoc, widget.options![1]);
                          },
                          child: Text(widget.options![1]),
                        ),
                      ),
                    ],
                  )
          else if (widget.questionType == "inputfield")
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    controller: inputField,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.question_answer_outlined),
                      labelText: 'Answer',
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    addDataToAnswerList(widget.questionLoc, inputField.text);
                  },
                  child: const Text("Next Question"),
                ),
              ],
            ),
          getDropDownWidget()
        ],
      ),
    );
  }
}
