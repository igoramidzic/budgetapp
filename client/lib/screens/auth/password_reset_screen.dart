import 'package:budgetapp/widgets/logout.dart';
import 'package:budgetapp/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  PasswordResetScreen({Key key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
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
                  LogoutButton(),
                  ResetPasswordForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
