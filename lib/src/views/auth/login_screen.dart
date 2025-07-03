import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../playpadi_library.dart';
import '../../controllers/user_Profile_controller.dart';
import '../../core/activity_overlay.dart';
import '../../services/device_info.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final client = APIClient();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final controller = UserProfileController();

  void _updateFCMToken(updates) async {
    final updatedProfile = await controller.updateFCMToken(updates);
  }

  void _processLogin() async {
    final deviceInfo = await getDeviceInfo();

    Map<String, String> data = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'device_type': deviceInfo['type']!,
      'device_name': deviceInfo['name']!,
    };

    LoadingOverlay.show(context);

    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      final updates = {'fcm_token': fcmToken};

      await client.login(data, () {
        debugPrint('Login successful');

        if (!mounted) return; // <- Important

        if (fcmToken != null) {
          print('FCM Token: ${fcmToken}');
          print('for server: $updates');
          _updateFCMToken(updates);
        }

        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      });
    } on NetworkErrorException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on InvalidResponseException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An Error Occured, Try Again',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on ServerErrorException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      LoadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
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
          child: Form(
            key: _formKey,
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.red.shade400,
                        width: 1.5,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Color.fromRGBO(199, 3, 125, 1)),
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Log in',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _processLogin();
                    }
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
