import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/screens/confirm_email_screen.dart';
import 'package:budgetapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _formValid;
  bool _loading;
  bool _hasError;
  String _errorString;

  @override
  void initState() {
    _name.addListener(checkFormValidity);
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
    _name.dispose();
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
      _formValid = _name.text.isNotEmpty &&
          _email.text.isNotEmpty &&
          _password.text.isNotEmpty;
    });
  }

  Future<void> signup() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _hasError = false;
      _errorString = '';
    });

    final String name = _name.text;
    final String email = _email.text;
    final String password = _password.text;

    AuthService authService = AuthService(email, password);

    if (password.length < 8) {
      setState(() {
        _loading = false;
        _hasError = true;
        _errorString = 'Password must be at least 8 characters.';
      });
      return;
    }

    try {
      Map<String, String> userAttributes = {
        'name': name,
        // additional attributes as needed
      };
      SignUpResult res = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmEmailScreen(authService)),
        (Route<dynamic> route) => false,
      );

      setState(() {
        _hasError = false;
        _errorString = '';
      });
    } on AuthException catch (e) {
      String message;

      setState(() {
        _hasError = true;
        _errorString = 'Something went wrong. Try again.';
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          enabled: textFieldEnabled,
          controller: _name,
          decoration: InputDecoration(
            hintText: 'First Name',
          ),
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Container(
          height: 20,
        ),
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
            hintText: 'Password (min. 8 characters)',
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
            tag: 'signupButtonAuth',
            child: ElevatedButton(
              child: Text('Sign up'),
              onPressed: buttonEnabled ? signup : null,
            ),
          ),
        ),
      ],
    );
  }
}
