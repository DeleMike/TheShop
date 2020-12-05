import 'package:flutter/material.dart';
import '../widgets/loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Loading(),
      ),
    );
  }
}
