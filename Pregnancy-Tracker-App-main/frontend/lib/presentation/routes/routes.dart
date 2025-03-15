
import 'package:frontend/presentation/BabyStatus/baby_status_page.dart';
import 'package:frontend/presentation/appointments/appointment_page.dart';
import 'package:frontend/presentation/bottom_nav/bottom_nav.dart';
import 'package:frontend/presentation/login/login_page.dart';
import 'package:frontend/presentation/profile/profile.dart';
import 'package:frontend/presentation/signup/signup_page.dart';
import 'package:frontend/presentation/tips/home_page.dart';
import 'package:go_router/go_router.dart';
import '../notes/symptoms/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    print("Reset Password button clicked"); // Debugging
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("Please enter your email.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage("Password reset email sent! Check your inbox.");
    } catch (e) {
      print("Error: $e"); // Debugging
      _showMessage("Error: ${e.toString()}");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your email to receive a password reset link:",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const LoginPage(),
    routes: [
    GoRoute(
      path: 'forgot-password',
      builder: (context, state) =>  ForgotPasswordPage(),
    ),
  ],
  ),
  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignUpPage(),
  ),
  GoRoute(
    path: '/landingpage',
    builder: (context, state) => const BottomNavigation(),
  ),
  GoRoute(
    path: '/notes',
    builder: (context, state) => const NotesPage(),
  ),
  GoRoute(
    path: '/tips',
    builder: (context, state) => const TipsHomePage(),
  ),
  GoRoute(
    path: '/appointments',
    builder: (context, state) => const AppointmentsPage(),
  ),
  GoRoute(
    path: '/calendar',
    builder: (context, state) => const BabyStatusPage(),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfilePage()
  ),
]);
