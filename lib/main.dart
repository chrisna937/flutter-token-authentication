
import 'package:flutter/material.dart';
import 'package:login_with_code_frontend/home_screen.dart';
import 'package:login_with_code_frontend/login_screen.dart';
import 'package:login_with_code_frontend/services/auth_service.dart';
import 'package:login_with_code_frontend/splash_screen.dart';



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
      home: SplashScreen(),
      
    );
  }
}



// //Auto login without check in splash screen
// Future<bool> _checkLogin() async {
//   final jwtAuth = await AuthService.getToken();
//   return jwtAuth != null;
// }


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // title: 'Flutter Demo',
//       home: FutureBuilder(
//         future: _checkLogin(),
//           builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Scaffold(
//               // body: Center(
//               //   child: CircularProgressIndicator(),
//               // ),
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
