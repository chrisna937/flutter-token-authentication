import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:login_with_code_frontend/create_eula_screen.dart';
import 'package:login_with_code_frontend/login_screen.dart';
import 'package:login_with_code_frontend/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
 String searchText = "";


  final String baseURL = 'http://192.168.100.77:3000';

  @override
  void initState() {
    super.initState();
    
  }

// @override
// void initState() {
//   super.initState();
//   _loadUser();
// }

// Future<void> _loadUser() async {
//   final prefs = await SharedPreferences.getInstance();
//   final userId = prefs.getString('user_id');
//   print("Logged in user: $userId");
// }

  Future<String?> getAuthenticationToken() async {
    return await storage.read(key: 'jwt_auth');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "AuthProfile with Eula",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
               Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
               );
            },
            child: CircleAvatar(backgroundImage: NetworkImage("")),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {
          //     print("Searched tapped");
          //   },
          // ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  print("Settings tapped");
                  break;
                   case 'eula':
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateEulaScreen()),
                  );
                   break;
                case 'logout':
                  final storage = FlutterSecureStorage();
                  storage.delete(key: 'jwt_auth');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'eula',
                child: Text('EULA'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text("Home Screen")),
              ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.chat),
      // ),
    );
  }
}
