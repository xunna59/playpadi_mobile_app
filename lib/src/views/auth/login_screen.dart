import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Log in to your account to continue',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.onSurface.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Log in',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.dashboard);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
