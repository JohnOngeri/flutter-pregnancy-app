import 'package:flutter/material.dart';
import 'package:frontend/presentation/signup/signup_page.dart';
import '../../core/CommonWidgets/back_arrow.dart';
import '../../core/constants/assets.dart';
import 'login_form.dart';
import 'package:frontend/presentation/forgot_password_page.dart'; // Make sure the import is correct

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  // Define a function for handling password reset
  void _handlePasswordReset() {
    // You can add any behavior to handle after password reset, like showing a message
    print("Password reset triggered");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: AssetImage(Assets.assetsImagesFancyBack)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LoginFormWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Navigate to ForgotPasswordPage and pass the callback
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(
                            onPasswordReset:
                                _handlePasswordReset, // Pass the callback here
                          ),
                        ),
                      );
                    },
                    child: const Text("Forgot Password?"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text("Create Account?"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
