import 'package:budgetapp/widgets/change_theme.dart';
import 'package:budgetapp/widgets/confirm_email_form.dart';
import 'package:flutter/material.dart';

class ConfirmEmailScreen extends StatefulWidget {
  ConfirmEmailScreen();

  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ChangeTheme(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
          child: EmailConfirmationForm(),
        ),
      ),
    );
  }
}
