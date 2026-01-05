import 'package:ayurvediccenter/Application/screens/LoginScreen/loginscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToLogin();
  }

  void _goToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/logo_make_11_06_2023_115 1.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),

          Center(
            child: Image.asset(
              'assets/images/Layer_1-2.png',
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
