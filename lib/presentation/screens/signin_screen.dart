// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';

import 'package:email_validator/email_validator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int cardIndex = 0;
  int lastIndex = 2;
  OverlayEntry? overlayEntry;

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context)
          .signInRequested(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    overlayEntry?.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => showOverlay());
  }

  List<Image> cards = [
    Image.asset(
      "assets/img_five.png",
      width: 200,
      height: 200,
    ),
    Image.asset(
      "assets/img_five.png",
      width: 200,
      height: 200,
    ),
    Image.asset(
      "assets/img_five.png",
      width: 200,
      height: 200,
    ),
  ];
  List<String> textFirstLine = [
    "Only 5 questions a day, and receive loads of points",
    "guyij",
    "guyij",
  ];
  List<String> textSecondLine = [
    "Redeem them for real money",
    "guyij",
    "guyij",
  ];

  Widget GetCardWidget() {
    return Positioned(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            cards[cardIndex],
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(textFirstLine[cardIndex]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(textSecondLine[cardIndex]),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (cardIndex > 0) {
                          setState(() {
                            cardIndex -= 1;
                            hideOverlay();
                            overlayEntry = OverlayEntry(
                              builder: (context) {
                                return GetCardWidget();
                              },
                            );
                            Overlay.of(context)?.insert(overlayEntry!);
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.arrow_left),
                    label: Text(""),
                  ),
                  const SizedBox(
                    width: 200,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (cardIndex >= lastIndex) {
                        hideOverlay();
                        print("Yes");
                      } else {
                        setState(() {
                          cardIndex += 1;
                        });
                        print(cardIndex);
                        hideOverlay();
                        overlayEntry = OverlayEntry(
                          builder: (context) {
                            return GetCardWidget();
                          },
                        );
                        Overlay.of(context)?.insert(overlayEntry!);
                      }
                    },
                    icon: const Icon(Icons.arrow_right),
                    label: const Text(""),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ),
      ),
      left: MediaQuery.of(context).size.width * 0.08,
      top: MediaQuery.of(context).size.height * 0.3,
    );
  }

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) {
        return GetCardWidget();
      },
    );
    final overlay = Overlay.of(context);
    overlay?.insert(overlayEntry!);
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey RPG"),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UnAuthenticated) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.adb_rounded, size: 150),
                      const Text(
                        'Survey RPG',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Center(
                        child: Form(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 10.0, 15.0, 10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null &&
                                            !EmailValidator.validate(value)
                                        ? 'Enter a valid email'
                                        : null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 10.0, 15.0, 10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && value.length < 6
                                        ? "Enter min. 6 characters"
                                        : null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _authenticateWithEmailAndPassword(context);
                                  },
                                  child: const Text('Sign In'),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/sign-up');
                                      },
                                      child: const Text('Sign Up'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          key: _formKey,
                        ),
                      )
                    ],
                  ),
                ),
              ));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
