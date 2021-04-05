import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/animations/fade_in_route.dart';
import 'package:budgetapp/screens/auth_screen.dart';
import 'package:budgetapp/screens/dashboard_screen.dart';
import 'package:budgetapp/screens/signup_screen.dart';
import 'package:budgetapp/widgets/change_theme.dart';
import 'package:budgetapp/widgets/logo_medium.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 1), () async {
      try {
        await Amplify.Auth.getCurrentUser();
        Navigator.push(context, FadeInRoute(page: DashboardScreen()));
      } catch (AuthException) {
        Navigator.push(context, FadeInRoute(page: AuthScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              child: Hero(
                tag: 'logoMedium',
                child: LogoMedium(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
