import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/screens/confirm_email_screen.dart';
import 'package:budgetapp/screens/dashboard_screen.dart';
import 'package:budgetapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _formValid;
  bool _loading;
  bool _hasError;
  String _errorString;

  @override
  void initState() {
    _email.addListener(checkFormValidity);
    _password.addListener(checkFormValidity);
    _formValid = false;
    _loading = false;
    _hasError = false;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get buttonEnabled {
    return _formValid && !_loading;
  }

  bool get textFieldEnabled {
    return !_loading;
  }

  void checkFormValidity() {
    setState(() {
      _formValid = _email.text.isNotEmpty && _password.text.isNotEmpty;
    });
  }

  void navigateUsingNextStep(SignInResult signInResult) {}

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _hasError = false;
      _errorString = '';
    });

    final String email = _email.text;
    final String password = _password.text;

    AuthService authService = AuthService(email, password);

    try {
      SignInResult res =
          await Amplify.Auth.signIn(username: email, password: password);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (Route<dynamic> route) => false,
      );
    } on AuthException catch (e) {
      if (e.message.contains("User is not confirmed")) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmEmailScreen(authService)),
          (Route<dynamic> route) => false,
        );
      } else if (e.message.contains("Incorrect username or password")) {
        setState(() {
          _hasError = true;
          _errorString = 'Incorrect email or password.';
        });
      } else if (e.message.contains("User does not exist")) {
        setState(() {
          _hasError = true;
          _errorString = 'No account found with this email.';
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(children: [
        TextField(
          enabled: textFieldEnabled,
          controller: _email,
          decoration: InputDecoration(
            hintText: 'Email',
          ),
          keyboardType: TextInputType.emailAddress,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Container(
          height: 20,
        ),
        TextField(
          enabled: textFieldEnabled,
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Password',
          ),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Container(height: 30),
        Container(
          child: Text(
            _hasError ? _errorString : '',
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        Container(height: 30),
        Container(
          width: double.infinity,
          child: Hero(
            tag: 'loginButtonAuth',
            child: ElevatedButton(
              child: Text('Log in'),
              onPressed: buttonEnabled ? login : null,
              style: Theme.of(context).elevatedButtonTheme.style.copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled))
                      return Color.fromRGBO(89, 112, 155, 1);
                    return Theme.of(context)
                        .colorScheme
                        .primaryVariant; // Use the component's default.
                  },
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
