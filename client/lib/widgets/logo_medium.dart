import 'package:flutter/material.dart';

class LogoMedium extends StatelessWidget {
  const LogoMedium({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: 100,
      width: 100,
    );
  }
}
