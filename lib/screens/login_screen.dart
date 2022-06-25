import 'package:flutter/material.dart';
import 'package:rare_crew_task/screens/dashboard_screen.dart';
import 'package:rare_crew_task/view_model/sign_in._view_model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

enum EmailSignIn { signIn, signUp }

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SignInViewModel {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  static const _colors = [
    Colors.white24,
    Colors.white,
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];

  void _onEmailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _submitData() async {
    if (formKey.currentState!.validate()) {}
    setState(() {
      isLoading = true;
    });
    await signIn(_emailController.text, _passwordController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DashboardScreen(
            accessToken: getAccessToken, refreshToken: getRefreshToken),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              WaveWidget(
                config: CustomConfig(
                  colors: _colors,
                  durations: _durations,
                  heightPercentages: _heightPercentages,
                ),
                backgroundColor: const Color(0xff10ADBC),
                size: Size(
                    double.infinity, MediaQuery.of(context).size.height / 1.3),
                waveAmplitude: 4,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login Screen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 50,
                      ),
                    ),
                    const Spacer(),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              onEditingComplete: _onEmailEditingComplete,
                              focusNode: _emailFocusNode,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                fillColor: Color(0xff10ADBC),
                                border: OutlineInputBorder(),
                                hintText: 'test@mail.com',
                                labelText: 'Email',
                              ),
                              validator: emailValidation,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: TextFormField(
                              focusNode: _passwordFocusNode,
                              controller: _passwordController,
                              obscuringCharacter: '*',
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                _submitData();
                              },
                              decoration: const InputDecoration(
                                fillColor: Color(0xff10ADBC),
                                border: OutlineInputBorder(),
                                hintText: 'Enter Your Password',
                                labelText: 'Password',
                              ),
                              validator: passwordValidation,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xff10ADBC),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: ElevatedButton(
                              onPressed: _submitData,
                              child: const Text('Sign In'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xff10ADBC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
