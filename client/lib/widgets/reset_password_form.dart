import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:budgetapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordForm extends StatefulWidget {
  ResetPasswordForm({Key key}) : super(key: key);

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _code = TextEditingController();
  final _newPassword = TextEditingController();

  bool _formValid;
  bool _loading;
  bool _hasError;
  String _errorString;

  @override
  void initState() {
    _code.addListener(checkFormValidity);
    _newPassword.addListener(checkFormValidity);
    _formValid = false;
    _loading = false;
    _hasError = false;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _code.dispose();
    _newPassword.dispose();
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
      _formValid = _code.text.isNotEmpty &&
          _code.text.length == 6 &&
          _newPassword.text.isNotEmpty &&
          _newPassword.text.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);

    Future<void> confirmPassword() async {
      FocusScope.of(context).unfocus();

      setState(() {
        _loading = true;
        _hasError = false;
        _errorString = '';
      });

      final String code = _code.text;
      final String newPassword = _newPassword.text;

      try {
        await authService.confirmPassword(code, newPassword);
        await authService.signIn(authService.email, newPassword);
        authService.navToNextSignInStep(context);
      } on CodeMismatchException catch (e) {
        print(e);
        setState(() {
          _hasError = true;
          _errorString = e.message;
        });
      } catch (e) {
        setState(() {
          _hasError = true;
          _errorString = "Something went wrong. Please try again.";
        });
      }

      setState(() {
        _loading = false;
      });
    }

    return SingleChildScrollView(
      reverse: true,
      child: Column(children: [
        TextField(
          enabled: textFieldEnabled,
          controller: _code,
          decoration: InputDecoration(
            hintText: 'Confirmation code (123456)',
            counterText: '',
          ),
          maxLength: 6,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Container(
          height: 20,
        ),
        TextField(
          enabled: textFieldEnabled,
          controller: _newPassword,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'New password (min. 8 characters)',
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
              child: Text('Reset password'),
              onPressed: buttonEnabled ? confirmPassword : null,
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
