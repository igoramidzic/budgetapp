import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/screens/auth_screen.dart';
import 'package:budgetapp/screens/dashboard_screen.dart';
import 'package:budgetapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  String email;
  String password;

  AuthService(this.email, this.password);

  void navigateToNextStepFromSignUpResult(
      SignUpResult signUpResult, BuildContext context) {
    if (signUpResult.isSignUpComplete) {
      signIn(context);
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      await Amplify.Auth.signIn(username: email, password: password);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Please log in again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
        (Route<dynamic> route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }
}
