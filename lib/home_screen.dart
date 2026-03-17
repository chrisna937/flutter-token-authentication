import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_with_code_frontend/config/app_config.dart' as AppConfig;
import 'package:login_with_code_frontend/login_screen.dart';
import 'package:login_with_code_frontend/services/auth_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String searchText = "";
  String authStatus = "Checking...";

  final String baseURL = AppConfig.baseURL;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final jwtAuth = await AuthService.getToken();

    setState(() {
      authStatus = jwtAuth != null ? "Token Verified" : "Not Authenticated";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Secure Login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user, size: 80),
              SizedBox(height: 20),
              Text(
                "Welcome!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("You are successfully logged in."),

              const SizedBox(height: 30),

              //Authentication Status Cards
              Card(
                elevation: 3,
                child:  ListTile(
                  leading: Icon(Icons.security),
                  title: Text("Authentication Status"),
                  subtitle: Text(authStatus),
                ),
              ),

              const SizedBox(height: 30),

              //Logout button
              ElevatedButton(
                onPressed: () async {
                  await AuthService.logout();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
