
import 'package:flutter/material.dart';
import 'package:login_with_code_frontend/home_screen.dart';
import 'package:login_with_code_frontend/login_screen.dart';
import 'package:login_with_code_frontend/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//Using Splash screen for token

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
        
      //   colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      // ),
      // home: LoginScreen(),
      home: SplashScreen(),
      
    );
  }
}



//Auto login without check in splash screen
// Future<bool> _checkLogin() async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('token');
//   return token != null;
// }


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       // theme: ThemeData(
        
//       //   colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//       // ),
//       home: FutureBuilder(
//         future: _checkLogin(),
//           builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }

//           if (snapshot.data == true) {
//             return const HomeScreen();
//           } else {
//             return const LoginScreen();
//           }
//         }),
      
//     );
//   }
// }
