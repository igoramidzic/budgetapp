import 'package:flutter/material.dart';

class OnboardingMainScreen extends StatelessWidget {
  const OnboardingMainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('Onboarding Main Screen'),
      ),
    );
  }
}
