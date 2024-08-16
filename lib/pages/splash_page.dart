import 'package:flutter/material.dart';

import '../apis/apis.dart';
import '../main.dart';
import 'bottom_nav_bar_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (APIs.auth.currentUser != null) {
        //navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavBarPage()),
        );
      } else {
        //navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return const SafeArea(child: Scaffold());
  }
}
