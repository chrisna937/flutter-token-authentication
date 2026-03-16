Secure Login System with JWT Authentication

A simple authentication system built with FLutter that demonstrates secure login using JWT tokens, OTP verification, and session handling.

This project showcases how modern mobile apps handle authentication, token storage, and user session management.

Features
 - User login authentication
 - JWT token-based authentication
 - OTP verification flow
 - Secure toen storage using FlutterSecureStorage
 - Persistent login session
 - Automatic login using splash screen
 - Logout functionality
 - Clean authentication service architecture

Tech Stack
 Frontend
  - Flutter
  - Dart

 Backend
  - Node.js
  - Express.js
  - PostgreSQL

Authentication
 - JWT (JSON Web Token)
 - OTP verification

Storage
 - FlutterSecureStorage (for JWT token)
 - SharedPreferences (for user data)

App Flow
 1. User logs in using email and password.
 2. Backend validates credentials.
 3. Backend returns a JWT token.
 4. Token is securely stored using FlutterSecureStorage.
 5. Splash screen checks if the token exists.
 6. If token exists - user goes directly to Home Screen.
 7. If not - user is redirected to Login Screen.

Screens
 - Splash Screen
 - Login Screen
 - OTP Verification Screen
 - Home Screen

Project Structure
 lib/
 │──main.dart    
 │── splash_screen.dart
 │── login_screen.dart
 │── home_screen.dart
 ├── services/
      └── auth_service.dart

How to Run the Project
 git clone https://github.com/chrisna937/flutter-token-authentication.git

Install dependencies:
 flutter pub get

Run the app
 flutter run

What I Learned
 - Implementing JWT authentication in Flutter
 - Managing secure token storage
 - Handling persistent login sessions
 - Structuring authentication services
 - Integrating Flutter with a Node.js backend

Author
Chrisna Mae A. Melo

License
This project is created for educational and portfolio purposes.

# Screenshots

## Splash Screen
![alt text](splash_screen.png)

### Login Screen
![alt text](login_screen.png)

#### Home Screen
![alt text](home_screen.png)

<!-- <html>
<h2>Splash Screen</h2>
<p align="center">
<img src="splash_screen.png" width="300">
</p>

<h2>Login Screen</h2>
<p align="center">
<img src="login_screen.png" width="300">
</p>

<h2>Home Screen</h2>
<p align="center">
<img src="home_screen.png" width="300">
</p>
</html>

<p align="center">
  <img src="splash_screen.png" width="300"/>
  &nbsp;&nbsp;&nbsp;
  <img src="login_screen.png" width="300"/>
  &nbsp;&nbsp;&nbsp;
  <img src="home_screen.png" width="300"/>
</p>

<p align="center">
  <em>Splash &nbsp;&nbsp;&nbsp; Login &nbsp;&nbsp;&nbsp; Home</em>
</p> -->



 
 
