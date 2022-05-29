// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surveymonkey_prototype/logic/cubit/auth_cubit.dart';

import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool termsAndConditionsAccepted = false;

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context)
          .signUpRequested(_emailController.text, _passwordController.text);
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.pushReplacementNamed(context, '/');
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
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      hintText: "Password",
                                      prefixIcon: Icon(Icons.password_outlined),
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
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                        value: termsAndConditionsAccepted,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            termsAndConditionsAccepted = value!;
                                          });
                                        }),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: const Text(
                                        "I accept all terms and conditions",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: !termsAndConditionsAccepted
                                        ? null
                                        : () {
                                            _authenticateWithEmailAndPassword(
                                                context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black12),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12),
                                      child: const Text('Sign Up',
                                          style:
                                              TextStyle(color: Colors.white70)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white60),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/');
                                        },
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
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
