import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/screens/auth/auth_screen.dart';
import 'package:budgetapp/screens/auth/login_screen.dart';
import 'package:budgetapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EmailConfirmationForm extends StatefulWidget {
  EmailConfirmationForm();

  @override
  _EmailConfirmationFormState createState() => _EmailConfirmationFormState();
}

class _EmailConfirmationFormState extends State<EmailConfirmationForm> {
  final _confirmationCode = TextEditingController();
  bool _isValid;
  bool _loading;
  bool _hasError;
  String _confirmationErrorMessage;
  Timer _resendTimer;
  int _resendTimeLeft;

  @override
  void initState() {
    super.initState();
    _confirmationCode.addListener(checkCodeValidity);
    _isValid = false;
    _loading = false;
    _resendTimeLeft = 0;
    _hasError = false;
    _confirmationErrorMessage = '';
  }

  @override
  void dispose() {
    super.dispose();
    _resendTimer?.cancel();
  }

  void checkCodeValidity() {
    final code = _confirmationCode.text;
    setState(() {
      _isValid = code.length == 6;
    });
  }

  bool get confirmButtonIsEnabled {
    return _isValid && !_loading;
  }

  bool get codeTextFieldIsEnabled {
    return !_loading;
  }

  void setCodeConfirmationErrorMessage(String message) {
    setState(() {
      _hasError = true;
      _confirmationErrorMessage = message;
    });
  }

  void resetCodeConfirmationErrorMessage() {
    setState(() {
      _hasError = false;
      _confirmationErrorMessage = '';
    });
  }

  bool get disableResendButton {
    return _loading || _resendTimeLeft > 0;
  }

  void startResendCodeTimer() {
    setState(() {
      _resendTimeLeft = 60;
    });
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _resendTimeLeft--;
      });
      if (_resendTimeLeft == 0) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);

    void resendCode() {
      Amplify.Auth.resendSignUpCode(username: authService.email).then((value) {
        startResendCodeTimer();
      }).catchError((err) {
        print(err);
      });
    }

    Future<void> confirmCode() async {
      resetCodeConfirmationErrorMessage();

      setState(() {
        _loading = true;
      });

      final String code = _confirmationCode.text;
      bool confirmed = false;
      try {
        await authService.confirmUser(code);
        confirmed = true;
      } on CodeMismatchException catch (e) {
        setCodeConfirmationErrorMessage(e.message);
      } on TooManyRequestsException catch (e) {
        setCodeConfirmationErrorMessage(e.message);
      } catch (e) {
        setCodeConfirmationErrorMessage(e.message);
      }

      if (!confirmed) {
        setState(() {
          _loading = false;
        });
        return;
      }

      try {
        String email = authService.email;
        String password = authService.password;
        await authService.signIn(email, password);
        authService.navToNextSignInStep(context);
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Please log in again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (Route<dynamic> route) => false,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }

      setState(() {
        _loading = false;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Hero(
              tag: 'logoMedium',
              child: Icon(
                Icons.email,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Container(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text('Enter Confirmation Code',
                      style: Theme.of(context).textTheme.headline5),
                  Container(height: 10),
                  Text(
                    'We\'ve sent the confirmation code to your email address.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(height: 20),
        SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              TextField(
                controller: _confirmationCode,
                autofocus: true,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'Confirmation code (123456)',
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                enabled: codeTextFieldIsEnabled,
              ),
              _hasError
                  ? Column(
                      children: [
                        Container(height: 20),
                        Text(
                          _confirmationErrorMessage,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    )
                  : Container(),
              Container(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Confirm'),
                  onPressed: confirmButtonIsEnabled ? confirmCode : null,
                ),
              ),
              Container(height: 10),
              TextButton(
                onPressed: disableResendButton ? null : resendCode,
                child: _resendTimeLeft == 0
                    ? Text('Resend Code')
                    : Text('Resend again in ' +
                        _resendTimeLeft.toString() +
                        ' seconds'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
