import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/constants/nextSignInSteps.dart';
import 'package:budgetapp/constants/nextSignUpSteps.dart';
import 'package:budgetapp/screens/auth/confirm_email_screen.dart';
import 'package:budgetapp/screens/dashboard_screen.dart';
import 'package:budgetapp/screens/auth/password_reset_screen.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  String _name;
  String _email;
  String _password;

  AuthNextSignInStep _nextSignInStep;
  AuthNextSignUpStep _nextSignUpStep;

  String get name => _name;
  String get email => _email;
  String get password => _password;
  AuthNextSignInStep get nextSignInStep => _nextSignInStep;
  AuthNextSignUpStep get nextSignUpStep => _nextSignUpStep;

  AuthService();

  Future<void> signIn(String email, String password) async {
    _email = email;
    _password = password;
    try {
      SignInResult signInResult =
          await Amplify.Auth.signIn(username: email, password: password);

      _nextSignInStep = signInResult.nextStep;
    } on NotAuthorizedException {
      throw new NotAuthorizedException("Incorrect email or password.",
          recoverySuggestion: "Make sure your email and password is correct.");
    } on UserNotFoundException catch (e) {
      throw e;
    } on UserNotConfirmedException {
      _nextSignInStep = new AuthNextSignInStep(
          codeDeliveryDetails: {}, signInStep: "CONFIRM_SIGN_UP_STEP");
    } on AuthException catch (e) {
      if (e.message.contains(
          "There is already a user which is signed in. Please log out the user before calling showSignIn.")) {
        await Amplify.Auth.signOut();
        throw new Exception("Something went wrong. Please try again.");
      } else if (e.message.contains("User is not confirmed.")) {
        _nextSignInStep = new AuthNextSignInStep(
            codeDeliveryDetails: {}, signInStep: "CONFIRM_SIGN_UP_STEP");
        throw new UserNotConfirmedException(e.message,
            underlyingException: e.underlyingException);
      }
      throw e;
    } catch (e) {
      throw new Exception("Something went wrong. Please try again.");
    }
  }

  Future<SignUpResult> signUp(
      String name, String email, String password) async {
    _name = name;
    _email = email;
    _password = password;
    Map<String, String> userAttributes = {
      "name": name,
    };
    try {
      CognitoSignUpOptions signUpOptions =
          CognitoSignUpOptions(userAttributes: userAttributes);
      SignUpResult signUpResult = await Amplify.Auth.signUp(
          username: email, password: password, options: signUpOptions);

      _nextSignUpStep = signUpResult.nextStep;

      return signUpResult;
    } catch (e) {
      throw e;
    }
  }

  Future<SignUpResult> confirmUser(String code) async {
    try {
      SignUpResult signUpResult = await Amplify.Auth.confirmSignUp(
          username: email, confirmationCode: code);
      _nextSignUpStep = signUpResult.nextStep;
      return signUpResult;
    } on CodeMismatchException catch (e) {
      throw e;
    } on TooManyRequestsException catch (e) {
      throw e;
    } catch (e) {
      throw new Exception("Something went wrong. Please try again.");
    }
  }

  Future<UpdatePasswordResult> confirmPassword(
      String code, String newPassword) async {
    try {
      UpdatePasswordResult updatePasswordResult =
          await Amplify.Auth.confirmPassword(
              username: email,
              newPassword: newPassword,
              confirmationCode: code);

      _nextSignInStep = new AuthNextSignInStep(
          codeDeliveryDetails: {}, signInStep: NextSignInStepConstants.done);
      return updatePasswordResult;
    } on CodeMismatchException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  void navToNextSignInStep(BuildContext context) {
    switch (_nextSignInStep.signInStep) {
      case NextSignInStepConstants.confirmSignUp:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmEmailScreen(),
            settings: RouteSettings(
              arguments: this,
            ),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case NextSignInStepConstants.resetPassword:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordResetScreen(),
            settings: RouteSettings(
              arguments: this,
            ),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case NextSignInStepConstants.done:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      default:
        print("NavToNextSignInStep default");
    }
  }

  void navToNextSignUpStep(BuildContext context) {
    switch (_nextSignUpStep.signUpStep) {
      case NextSignUpStepConstants.ConfirmSignUp:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmEmailScreen(),
            settings: RouteSettings(
              arguments: this,
            ),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      default:
        print("NavToNextSignUpStep default");
    }
  }
}

enum EAuthAction { SignUp, SignIn }
