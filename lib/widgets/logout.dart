import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      await Amplify.Auth.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (route) => false);
    }

    return ElevatedButton(
      child: Text('Logout'),
      onPressed: logout,
    );
  }
}
