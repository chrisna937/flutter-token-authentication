Secure Login System with JWT Authentication

A simple authentication system built with Flutter that demonstrates secure login using JWT tokens, OTP verification, and session handling.

This project showcases how modern mobile apps handle authentication, token storage, and user session management.

Features
 - User login authentication
 - JWT token-based authentication
 - OTP verification flow
 - Secure token storage using FlutterSecureStorage
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
 │     └── auth_service.dart
 ├── config
       └── app_config.dart

# How to Run the Project

## 1. Clone the repository & the server
Frontend
git clone https://github.com/chrisna937/flutter-token-authentication.git

Backend
git clone https://github.com/chrisna937/flutter-token-authentication-server.git

## 2. Install dependencies
flutter pub get

## 3.Configure Backend URL
 This project uses a local Node.js backend.

 Open:
 lib/config/app_config.dart

 Update the base URL:

```dart
  final String baseURL = 'http://YOUR_IP_ADDRESS:3000'; 
Replace YOUR_IP_ADDRESS with your local machine IP.

Example:
http://192.168.1.5:3000

## 4. Setup Backend (Node.js + PostgreSQL)
Install backend dependencies:
npm install
npm --save-dev nodemon 

## 5. Create a .env file paste this:
JWT_SECRET="YOUR_JWT_SECRET",

POSTGRES_CONN_URI="postgresql://postgres:your_password@localhost:5432/postgres"
SCHEMA="SCHEMA_NAME"

# nodemailer
EMAIL_USER=your_email@example.com
EMAIL_PASS=your_email_password

Replace all values with your own configuration.

Generating JWT Secret
The JWT_SECRET is used to sign authentication tokens.

You can generate one using Node.js:

 node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

Copy the generated value and place it in your .env file:

JWT_SECRET="your_generated_secret_here"

Setting up Email (Nodemailer)
This project uses Nodemailer to send OTP verification emails.

Option1: Gmail (Recommended for testing)

1. Go to your Google Account Settings
2. Enable 2-Step Verfication
3. Generate an App Password

Use the generated credentials in your .env:

EMAIL_USER=your_email@gmail.com 
EMAIL_PASS=your_app_password

Note: Do not use your real Gmail password. Always use an App Password.

Option 2: Other Email Providers
You can also use other SMTP services like Outlook or Yahoo.

Example:

EMAIL_USER=your_email@gmail.com 
EMAIL_PASS=your_app_password

Make sure your provider allows SMTP access:

Important Notes
 - Never commit your .env file to Github
 - Always keep your JWT_SECRET and email credentials private
 - These values are required for authentication and OTP features to work 


## 6. Setup Database
Make sure PostgreSQL is installed and running.

 1. Create a SCHEMA

```sql
CREATE SCHEMA YOUR_SCHEMA_NAME;

 2. Import Table Scripts
 In flutter-token-authentication-server Run the provided SQL file located in .sql file.


## 7. Run the Backend Server
npm run dev

## 8. Run the Flutter app
flutter run

Notes
 - This project uses a local backend, so both your emulator/device and backend must be  on the same network.
 - Email (OTP) functionality requires valid email credentials.
 - Dabase setup is required to fully runt the project.


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

## Login Screen
![alt text](login_screen.png)

### Home Screen
![alt text](home_screen.png)




 

