import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../utils/helpers/auth_provider.dart';
import '../provider/login_provider.dart';

enum Status {
  login,
  signUp,
}

Status type = Status.login;

class LoginPage extends StatelessWidget {
  static const routename = '/LoginPage';
  LoginPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyAppColors.whiteColor,
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          final _auth = ref.watch(authenticationProvider);
          final loginlogic = ref.watch(loginProviderlogic);

          Future<void> _onPressedFunction() async {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            if (type == Status.login) {
              loginlogic.loading();
              await _auth
                  .signInWithEmailAndPassword(
                      loginlogic.email.text, loginlogic.password.text, context)
                  .whenComplete(
                      () => _auth.authStateChange.listen((event) async {
                            if (event == null) {
                              loginlogic.loading();
                              return;
                            }
                          }));
            } else {
              loginlogic.loading();
              await _auth
                  .signUpWithEmailAndPassword(
                      loginlogic.email.text, loginlogic.password.text, context)
                  .whenComplete(
                      () => _auth.authStateChange.listen((event) async {
                            if (event == null) {
                              loginlogic.loading();
                              return;
                            }
                          }));
            }
          }

          Future<void> _loginWithGoogle() async {
            loginlogic.loading2();
            await _auth
                .signInWithGoogle(context)
                .whenComplete(() => _auth.authStateChange.listen((event) async {
                      if (event == null) {
                        loginlogic.loading2();
                        return;
                      }
                    }));
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/dukkantek.jpeg",
                            width: 150,
                            height: 150,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: MyAppColors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: loginlogic.email,
                            autocorrect: true,
                            enableSuggestions: true,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {},
                            decoration: const InputDecoration(
                              hintText: 'Email address',
                              hintStyle: TextStyle(color: Colors.black54),
                              icon: Icon(Icons.email_outlined,
                                  color: MyAppColors.deepPurple, size: 24),
                              alignLabelWithHint: true,
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                              color: MyAppColors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: loginlogic.password,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.black54),
                              icon: Icon(CupertinoIcons.lock_circle,
                                  color: MyAppColors.deepPurple, size: 24),
                              alignLabelWithHint: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (type == Status.signUp)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                                color: MyAppColors.deepPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25)),
                            child: TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Confirm password',
                                hintStyle: TextStyle(color: Colors.black54),
                                icon: Icon(CupertinoIcons.lock_circle,
                                    color: MyAppColors.deepPurple, size: 24),
                                alignLabelWithHint: true,
                                border: InputBorder.none,
                              ),
                              validator: type == Status.signUp
                                  ? (value) {
                                      if (value != loginlogic.password.text) {
                                        return 'Passwords do not match!';
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                      width: double.infinity,
                      decoration:
                          const BoxDecoration(color: MyAppColors.whiteColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 32.0),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child: loginlogic.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : MaterialButton(
                                    onPressed: _onPressedFunction,
                                    child: Text(
                                      type == Status.login
                                          ? 'Log in'
                                          : 'Sign up',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    textColor: MyAppColors.deepPurple,
                                    textTheme: ButtonTextTheme.primary,
                                    minWidth: 100,
                                    padding: const EdgeInsets.all(18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: const BorderSide(
                                          color: MyAppColors.deepPurple),
                                    ),
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 32.0),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            child: loginlogic.isLoading2
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : MaterialButton(
                                    onPressed: _loginWithGoogle,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        FaIcon(FontAwesomeIcons.google),
                                        Text(
                                          ' Login with Google',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    textColor: MyAppColors.deepPurple,
                                    textTheme: ButtonTextTheme.primary,
                                    minWidth: 100,
                                    padding: const EdgeInsets.all(18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: const BorderSide(
                                          color: MyAppColors.deepPurple),
                                    ),
                                  ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: RichText(
                              text: TextSpan(
                                text: type == Status.login
                                    ? 'Don\'t have an account? '
                                    : 'Already have an account? ',
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: type == Status.login
                                          ? 'Sign up now'
                                          : 'Log in',
                                      style: const TextStyle(
                                          color: MyAppColors.deepPurple),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          loginlogic.switchType();
                                        })
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
