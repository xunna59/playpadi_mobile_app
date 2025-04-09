import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../widgets/auth_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              'assets/background/onboarding_background.png',
            ), // Your image path
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Image.asset('assets/logo/Icon - Main.png', height: 80),
            const SizedBox(height: 24),
            const Text(
              'Want to have fun playing?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Log in or create an account',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 32),
            AuthButton(
              imageUrl: 'assets/icons/apple.png',
              text: 'Continue with Apple',
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            AuthButton(
              imageUrl: 'assets/icons/google.png',
              text: 'Continue with Google',
              onPressed: () {},
            ),

            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.white54)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: Colors.white70)),
                ),
                Expanded(child: Divider(color: Colors.white54)),
              ],
            ),
            const SizedBox(height: 12),
            AuthButton(
              imageUrl: 'assets/icons/email.png',
              text: 'Continue with Email',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.registerStepOne);
              },
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                text: 'By registering you are accepting our ',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                children: [
                  TextSpan(
                    text: 'terms of use',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'privacy policy',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
