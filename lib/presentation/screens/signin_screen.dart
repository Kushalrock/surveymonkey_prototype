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

  void _forgotPassword(context, String email) {
    if (EmailValidator.validate(email) && email.isNotEmpty) {
      BlocProvider.of<AuthCubit>(context).forgotPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Your password reset mail has been sent!")));
      _emailController.text = "";
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter a valid email!")));
    }
  }

  @override
  void dispose() {
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
      "assets/sign_in_screen_1.png",
      width: 200,
      height: 200,
    ),
    Image.asset(
      "assets/sign_in_screen_2.png",
      width: 200,
      height: 200,
    ),
    Image.asset(
      "assets/sign_in_screen_3.png",
      width: 200,
      height: 200,
    ),
  ];
  List<String> textFirstLine = [
    "Only 5 questions a day, and receive loads of points",
    "Play Games, Answer Questions, Have Fun",
    "Fun is rewarding, Earn points",
  ];
  List<String> textSecondLine = [
    "Redeem them for real money",
    "Have a good time",
    "Redeem it for paypal or donate it to charity",
  ];

  Widget getCardWidget() {
    return Positioned(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.88,
          height: MediaQuery.of(context).size.height * 0.47,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 163, 189, 237),
                  Color.fromARGB(255, 105, 145, 199)
                ],
                begin: FractionalOffset(1.0, 0.0),
                end: FractionalOffset(0.0, 0.0),
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
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
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (cardIndex > 0) {
                            setState(() {
                              cardIndex -= 1;
                              hideOverlay();
                              overlayEntry = OverlayEntry(
                                builder: (context) {
                                  return getCardWidget();
                                },
                              );
                              Overlay.of(context)?.insert(overlayEntry!);
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.arrow_left),
                    ),
                    Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: Text((cardIndex + 1).toString() +
                          "/" +
                          (lastIndex + 1).toString()),
                    ),
                    IconButton(
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
                              return getCardWidget();
                            },
                          );
                          Overlay.of(context)?.insert(overlayEntry!);
                        }
                      },
                      icon: const Icon(Icons.arrow_right),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              )
            ],
          ),
        ),
      ),
      left: MediaQuery.of(context).size.width * 0.05,
      top: MediaQuery.of(context).size.height * 0.3,
    );
  }

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (context) {
        return getCardWidget();
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
      appBar: null,
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
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 9, 32, 63),
                      Color.fromARGB(255, 83, 120, 149),
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                  ),
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.adb_rounded, size: 150),
                        const Text(
                          'Coinkick',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(
                          height: (MediaQuery.of(context).size.height * 0.05),
                        ),
                        Center(
                          child: Form(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  child: Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        hintText: "Email",
                                        prefixIcon: Icon(Icons.email_outlined),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  child: Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _passwordController,
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        prefixIcon:
                                            Icon(Icons.password_outlined),
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
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(
                                          context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black12),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.only(top: 12, bottom: 12),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: TextButton(
                                    onPressed: () {
                                      _forgotPassword(
                                          context, _emailController.text);
                                    },
                                    child: const Text(
                                      "Forgot your password?",
                                      style: TextStyle(color: Colors.white60),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/sign-up');
                                        },
                                        child: const Text(
                                          'Create One',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
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
                )),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
