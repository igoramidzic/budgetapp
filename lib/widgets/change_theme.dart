import 'package:budgetapp/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class ChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      child: FlutterSwitch(
        width: 75.0,
        height: 40.0,
        valueFontSize: 15.0,
        toggleSize: 30.0,
        value: themeProvider.isDarkMode,
        borderRadius: 30.0,
        padding: 5.0,
        activeColor: Theme.of(context).colorScheme.secondaryVariant,
        inactiveColor: Colors.grey[200],
        toggleColor: themeProvider.isDarkMode ? Colors.black87 : Colors.white,
        inactiveIcon: Icon(
          Icons.wb_sunny,
          color: Colors.yellow[600],
          size: 20,
        ),
        activeIcon: Icon(
          Icons.nightlight_round,
          color: Colors.yellow,
          size: 20,
        ),
        onToggle: (value) {
          themeProvider.toggleTheme(value);
        },
      ),
    );
  }
}
