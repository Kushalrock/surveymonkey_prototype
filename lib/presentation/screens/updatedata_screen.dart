import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateData extends StatefulWidget {
  final String currentData;
  final String typeOfData;
  final funcOnSuccess;

  const UpdateData(
      {Key? key,
      required this.currentData,
      required this.typeOfData,
      required this.funcOnSuccess})
      : super(key: key);

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  TextEditingController controllerForField = TextEditingController();
  TextEditingController controllerForOtherField = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void onSuccessfulVerification() {
    if (widget.typeOfData == "Display Name") {
      widget.funcOnSuccess(controllerForField.text);
    } else if (widget.typeOfData == "Password") {
      widget.funcOnSuccess(
          controllerForField.text, controllerForOtherField.text);
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    controllerForField.dispose();
    controllerForOtherField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 18, 18, 18),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 18, 18, 18),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Current ' + widget.typeOfData,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.98,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 0.5,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            widget.typeOfData == "Password"
                                ? "Can't be displayed due to security reasons"
                                : widget.currentData,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Updated ' + widget.typeOfData,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.typeOfData == "Password"
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  controller: controllerForOtherField,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Old Password"),
                                  validator: (value) {
                                    return value == null
                                        ? 'Enter a valid ' + widget.typeOfData
                                        : null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: controllerForField,
                            maxLength:
                                widget.typeOfData == "Display Name" ? 8 : null,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            validator: (value) {
                              return value == null
                                  ? 'Enter a valid ' + widget.typeOfData
                                  : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        TextButton.icon(
                          icon: const FaIcon(Icons.send_outlined),
                          onPressed: () {
                            !_formKey.currentState!.validate()
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Enter a valid ' + widget.typeOfData),
                                    ),
                                  )
                                : onSuccessfulVerification();
                          },
                          label: Text("Change " + widget.typeOfData),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
