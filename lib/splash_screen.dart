import 'package:flutter/material.dart';
import 'package:login_with_code_frontend/home_screen.dart';
import 'package:login_with_code_frontend/login_screen.dart';
import 'package:login_with_code_frontend/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  //autologin
  void _checkToken()  async {
    await Future.delayed(const Duration(seconds: 2));

    final jwtAuth = await AuthService.getToken();

    if (jwtAuth != null) {
      //Token exists, navigate to Home
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      //Stay on login screen
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text("Secure Login System",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text("Checking authentication...",
              style: TextStyle(fontSize: 16, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}