import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:budgetapp/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

class AmplifyConfigProvider extends ChangeNotifier {
  AmplifyConfigProvider() {
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (Amplify.isConfigured) return;
    try {
      await Amplify.addPlugins([
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(),
        AmplifyAuthCognito(),
      ]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      // print("Amplify was already configured. Was the app restarted?");
    } catch (e) {}
  }
}
