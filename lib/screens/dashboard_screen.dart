import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/screens/auth_screen.dart';
import 'package:budgetapp/widgets/logout.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthUser _user;
  List<AuthUserAttribute> _attributes;

  @override
  void initState() {
    super.initState();

    setState(() {
      _attributes = [];
    });

    Amplify.Auth.fetchUserAttributes().then((attributes) {
      setState(() {
        _attributes = attributes;
      });
    }).catchError((err) {
      print(err);
    });

    Amplify.Auth.getCurrentUser().then((user) {
      setState(() {
        _user = user;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(_user != null ? _user.userId : 'loading...'),
            LogoutButton(),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: _attributes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_attributes[index].value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
