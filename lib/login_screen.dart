import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_with_code_frontend/home_screen.dart';
import 'package:login_with_code_frontend/services/auth_service.dart';
import 'package:login_with_code_frontend/widgets/eula_dialog.dart';
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
  final String baseURL = 'http://192.168.100.77:3000';

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

  //with prints
Future<void> _verifyOtp() async {
  final email = _emailController.text.trim();
  final otp = _otpController.text.trim();

  print("Starting OTP verification for email: $email, otp: $otp");

  if (otp.length != 6) {
    _showMessage("Enter valid 6-digit OTP");
    print("OTP length invalid");
    return;
  }

  setState(() => _isLoading = true);

  try {
    final response = await http.post(
      Uri.parse('$baseURL/api/verify-otp'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    print("Server responded with status: ${response.statusCode}");

    final data = jsonDecode(response.body);
    print("Response body: $data");

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      // Store user info
      await prefs.setString('token', data['token']);
      await prefs.setString('userid', data['userid'].toString());
      await prefs.setString('email', data['email']);
      print("Saved token and user info in SharedPreferences");

      if (data['eula_required'] == true) {
        print("EULA required for this user");
        final eula = data['eula'];
        print("Active EULA details: $eula");

  //       //Convert types safely
  //       final versionCode = eula['version_code']?.toString() ?? '';
  //       final content = eula['content']?.toString() ?? '';
  //       final versionId = eula['versionid'] is int
  //           ? eula['versionid']
  //           : int.tryParse(eula['versionid'].toString()) ?? 0;

  //  print("Active EULA details after type fix: versionCode=$versionCode, content=$content, versionId=$versionId");

        // Show EULA dialog
        final accepted = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => EulaDialog(
            versionCode: eula['version_code'].toString(),
            content: eula['content'].toString(),
            versionId: eula['versionid'] is int
                 ? eula['versionid']
                 : int.tryParse(eula['versionid'].toString()) ?? 0,
            userId:data['userid'] is int
                 ? data['userid']
                 : int.tryParse(data['userid'].toString()) ?? 0,
            onAccept: (userId, versionId) async {
              // print("User accepting EULA: userId=$userId, versionId=$versionId");
               
     final userId = await AuthService.getUserId();
     final token = await AuthService.getToken();
    //  debugPrint("userId retrieved: $userId");

      if (userId == null || token == null) {
        throw Exception("User not logged in");
      }
             
              final resp = await http.post(
                Uri.parse("$baseURL/api/eula-acceptance"),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $token"
                          },
              );
              //   body: jsonEncode({
              //     "userid": userId,
              //     // "eula_version_id": versionId,
              //     "accepted_at": DateTime.now().toIso8601String(),
              //   }),
              // );
              print("EULA acceptance response status: ${resp.statusCode}");
              return resp.statusCode == 200 || resp.statusCode == 201;
            },
          ),
        );

        if (accepted != true) {
          print("User cancelled EULA dialog");
          return; // User cancelled - do not proceed
        }

        print("User accepted EULA");
      } else {
        print("No EULA required");
      }

      // Navigate to HomeScreen
      print("Navigating to HomeScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showMessage(data["message"] ?? "Invalid OTP");
      print("OTP verification failed: ${data["message"]}");
    }
  } catch (e) {
    _showMessage("Server error");
    print("Error during OTP verification: $e");
  }

  setState(() => _isLoading = false);
  print("OTP verification finished, loading state set to false");
}



  // Future<void> _verifyOtp() async {
  //   final email = _emailController.text.trim();
  //   final otp = _otpController.text.trim();

  //   if (otp.length != 6) {
  //     _showMessage("Enter valid 6-digit OTP");
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseURL/api/verify-otp'),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"email": email, "otp": otp}),
  //     );

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //     // _showMessage("Login successful!");

  //      final prefs= await SharedPreferences.getInstance();
       
  //      //Store user info
  //      await prefs.setString('token', data['token']);
  //      await prefs.setString('userid', data['userid'].toString());
  //      await prefs.setString('email', data['email']);

  //      if (data['eula_required'] == true) {

  //       final eula = data['eula'];
       

  //     //  final userId = data['userid'];
       
  //     //Fetch active EULA
  //     // final eulaResponse = await http.get(
  //     //   Uri.parse("$baseURL/api/eula-active")
  //     //   );

  //     // if (eulaResponse.statusCode == 200) {

  //     //   final eulaData = jsonDecode(eulaResponse.body);

  //     //   final int versionId = int.parse(eulaData['versionid'].toString());
  //     //   final String versionCode = eulaData['version_code'];
  //     //   final String content = eulaData['content'];

  //     //   //Check if user has accepted this EULA version
  //     //   final acceptanceResponse = await http.get(
  //     //     Uri.parse(
  //     //     "$baseURL/api/eula-acceptance?userid=$userId&versionid=$versionId"));
        
  //     //   final acceptedData = jsonDecode(acceptanceResponse.body);
  //     //   final bool hasAccepted = acceptedData['accepted'] ?? false;
      
  //     //   // final hasAccepted = acceptanceResponse.statusCode == 200 && 
  //     //   //      jsonDecode(acceptanceResponse.body)['accepted'] == true;
        
  //     //   if (!hasAccepted) {
  //         //Show EULA dialog before HomeScreen
  //         final accepted = await showDialog<bool>(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (_) => EulaDialog(
  //             versionCode: eula['version'],
  //             content: eula['content'],
  //              versionId:  eula['versionid'],
  //               userId: data['userid'], 
  //             onAccept: (userId, versionId) async {

  //           final resp = await http.post(
  //             Uri.parse("$baseURL/api/eula-acceptance"),
  //             headers: {"Content-Type": "application/json"},
  //             body: jsonEncode({
  //               "userid": userId,
  //               "eula_version_id": versionId,
  //               "accepted_at": DateTime.now().toIso8601String(),

                
  //             }),
              
  //           );
  //           print("Verify OTP response: $data");
  //           return resp.statusCode == 200 || resp.statusCode == 201;
  //         },
  //       ),
  //     );
  //     if (accepted != true) return; 
  //       //User cancelled - logout or block further actions
  //     }
    
        
      
        
  //       //Navigate to HOme
  //       Navigator.pushReplacement(
  //         context, 
  //         MaterialPageRoute(
  //           builder: (context) => const HomeScreen(),));
    
    
  
  //     } else {
  //       _showMessage(data["message"] ?? "Invalid OTP");
  //     }
  //   } catch (e) {
  //     _showMessage("Server error");
  //   }
  //   setState(() => _isLoading = false);
  // }

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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const Icon(Icons.chat, size: 80, color: Colors.blue),
                SizedBox(
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  // child: Image.asset(
                  //   "assets/icon/chat_app_icon3.png",
                  //   fit: BoxFit.contain, //fit: BoxFitScover,

                  // ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 32),

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
                const SizedBox(height: 24),

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
