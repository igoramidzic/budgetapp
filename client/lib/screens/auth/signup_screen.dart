import 'package:budgetapp/widgets/change_theme.dart';
import 'package:budgetapp/widgets/logo_medium.dart';
import 'package:budgetapp/widgets/signup.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: ChangeTheme(),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 65),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Hero(
                    tag: 'logoMedium',
                    child: LogoMedium(),
                  ),
                  Container(height: 80),
                  SignupForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
