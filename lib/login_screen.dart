import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:login_with_code_frontend/config/app_config.dart' as AppConfig;
import 'package:login_with_code_frontend/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _otpSent = false;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // final String baseURL =
  //     'https://link'; //cloud
  final String baseURL = AppConfig.baseURL;

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("Please enter your email");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseURL/api/send-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _otpSent = true;
        });

        _showMessage("OTP sent to your email");
      } else {
        _showMessage(data["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
      _showMessage("Server error");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showMessage("Enter valid 6-digit OTP");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseURL/api/verify-otp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      final data = jsonDecode(response.body);
      // print("Response body: ${response.body}");
      // print("Decoded data: $data");

      if (response.statusCode == 200) {
        const storage = FlutterSecureStorage();

        //Store JWT securely
        await storage.write(key: 'jwt_auth', value: data['token']);

        //Store user info in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userid', data['userid'].toString());
        await prefs.setString('email', data['email']);


        // Navigate to HomeScreen
        // print("Navigating to HomeScreen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showMessage(data["message"] ?? "Invalid OTP");
      }
    } catch (e) {
      print(e);
      _showMessage("Server error");
    }

    setState(() => _isLoading = false);
  }

  void _showMessage(
    String message, {
    int durationSeconds = 7,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: durationSeconds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SizedBox(
                //   height: screenHeight * 0.15,
                //   width: double.infinity,
                // ),
                // const SizedBox(height: 16),

                const Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _emailController,
                  // obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                if (_otpSent)
                  Column(
                    children: [
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter OTP",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _otpSent
                      ? _verifyOtp
                      : _sendOtp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_otpSent ? "Verify OTP" : "Send OTP"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
