import 'package:budgetapp/provider/amplify_config_provider.dart';
import 'package:budgetapp/provider/theme_provider.dart';
import 'package:budgetapp/screens/auth/auth_screen.dart';
import 'package:budgetapp/screens/auth/loading_screen.dart';
import 'package:budgetapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AmplifyConfigProvider()),
        ChangeNotifierProvider.value(value: AuthService()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: themeProvider.isDarkMode
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: MaterialApp(
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,
                themeMode: themeProvider.themeMode,
                debugShowCheckedModeBanner: false,
                title: 'Budget App',
                initialRoute: '/',
                routes: <String, WidgetBuilder>{
                  "/": (BuildContext context) => LoadingScreen(),
                  "/auth": (BuildContext context) => AuthScreen(),
                }),
          );
        },
      ),
    );
  }
}
