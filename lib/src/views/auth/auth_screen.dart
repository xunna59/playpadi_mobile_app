import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../playpadi_library.dart';
import '../../routes/app_routes.dart';
import '../../widgets/auth_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _handleGoogleSignIn() async {
    final client = APIClient();

    try {
      await client.signInWithGoogle();

      if (!mounted) return;

      // Should only get here if token was found
      // debugPrint(
      //   '✅ signInWithGoogle succeeded; isAuthorized=${client.isAuthorized}, token=${client.token}',
      // );

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e, stack) {
      debugPrint('❌ _handleGoogleSignIn caught → $e\n$stack');
      if (!mounted) return;

      String errorMessage;

      if (e is UserCanceledSignInException) {
        errorMessage = 'Sign-in was canceled. Please try again.';
      } else if (e is TokenNotFoundException) {
        errorMessage = 'Token not found in the authentication response.';
      } else {
        errorMessage = 'An unexpected error occurred. Please try again.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              'assets/background/onboarding_background.png',
            ),
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

            const SizedBox(height: 32),
            AuthButton(
              imageUrl: 'assets/icons/apple.png',
              text: 'Continue with Apple',
              onPressed: () {}, // Optional: Add Apple sign-in later
            ),
            const SizedBox(height: 12),
            AuthButton(
              imageUrl: 'assets/icons/google.png',
              text: 'Continue with Google',
              // onPressed: () => _handleGoogleSignIn(),
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
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.white70),
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: const TextStyle(
                      color: Color.fromRGBO(199, 3, 125, 1),
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                  ),
                  const TextSpan(text: ' or create an account'),
                ],
              ),
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
                      decoration: TextDecoration.none,
                      color: Color.fromRGBO(199, 3, 125, 1),
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.termsOfUseScreen,
                            );
                          },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'privacy policy',
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Color.fromRGBO(199, 3, 125, 1),
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.privacyPolicyScreen,
                            );
                          },
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
