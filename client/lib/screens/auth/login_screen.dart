import 'package:budgetapp/widgets/login.dart';
import 'package:budgetapp/widgets/logo_medium.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
