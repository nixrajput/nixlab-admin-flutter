import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nixlab_admin/helpers/validators.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/screens/home.dart';
import 'package:nixlab_admin/widgets/custom_outlined_button.dart';
import 'package:nixlab_admin/widgets/custom_text_button.dart';
import 'package:nixlab_admin/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordResetController = TextEditingController();
  final _passwordController = TextEditingController();
  late FirebaseProvider _firebaseProvider;
  var _obscureText = true;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordResetController.dispose();
  }

  Future<void> _loginUser(var email, var password) async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        setState(() {
          _isLoading = false;
        });
        await _firebaseProvider.getUserInfo(result.user!.uid);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        _passwordController.clear();
        final snackBar = SnackBar(
          content: Text(err.message),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      final snackBar = SnackBar(
        content: Text("Email and password can't be empty."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _sendPasswordResetLink() async {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _passwordResetController.text)
        .then((_) {
      _passwordResetController.clear();
      final snackBar = SnackBar(
        content: Text("Password reset link has been sent."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((err) {
      final snackBar = SnackBar(
        content: Text(err.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: bodyWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: bodyHeight * 0.1),
                Image.asset(
                  'assets/images/logo.png',
                  height: 100.0,
                ),
                SizedBox(height: bodyHeight * 0.1),
                _loginFormControls(bodyHeight)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _loginFormControls(double height) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: _isLoading
            ? Column(
                children: [
                  SizedBox(height: height * 0.1),
                  LoadingIndicator(),
                ],
              )
            : Column(
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    '${'Login to Account'}'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email can't be empty";
                      } else if (!Validators.isValidEmail(value)) {
                        return "Invalid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password can't be empty";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Text(
                            _obscureText ? "Show" : "Hide",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )),
                  ),
                  const SizedBox(height: 20.0),
                  CustomTextButton(
                    onTap: _showPasswordResetDialog,
                    label: 'Forgot Password?',
                  ),
                  const SizedBox(height: 40.0),
                  CustomOutlinedButton(
                    onTap: () => _loginUser(
                      _emailController.text,
                      _passwordController.text,
                    ),
                    label: 'Next',
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 60.0,
                    ),
                  )
                ],
              ),
      );

  _showPasswordResetDialog() {
    return showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Password Reset'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your email associated with your account. '
                  'We will send a password reset link to the '
                  'provided email.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _passwordResetController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can't be empty";
                    } else if (!Validators.isValidEmail(value)) {
                      return "Invalid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(
                'Close'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _sendPasswordResetLink();
              },
              child: Text(
                'Send'.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
