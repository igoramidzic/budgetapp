import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/models/User.dart';
import 'package:budgetapp/widgets/logout.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AuthUser _user;
  final String id = 'abc123';

  @override
  void initState() {
    super.initState();

    // Timer.periodic(Duration(seconds: 2), (timer) {
    //   Amplify.Auth.getCurrentUser().then((user) {
    //     setState(() {
    //       _user = user;
    //     });
    //   }).catchError((err) {
    //     print(err);
    //   });
    //   timer.cancel();
    // });
  }

  onCreate() async {
    final user =
        new User(onboarding_completed: true, email: 'test', name: 'Igor');
    try {
      await Amplify.DataStore.save(user);

      print("Successfully saved");
    } catch (e) {
      print(e);
    }
  }

  onGetUser() async {
    try {
      // await Amplify.DataStore.clear();
      List<User> users = await Amplify.DataStore.query(User.classType);
      print(users);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LogoutButton(),
            ElevatedButton(
              onPressed: onCreate,
              child: Text('Create'),
            ),
            ElevatedButton(
              onPressed: onGetUser,
              child: Text('Get'),
            ),
          ],
        ),
      ),
    );
  }
}
