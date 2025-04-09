import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterStepTwo extends StatefulWidget {
  const RegisterStepTwo({super.key});

  @override
  State<RegisterStepTwo> createState() => _RegisterStepTwoState();
}

class _RegisterStepTwoState extends State<RegisterStepTwo> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool wantsUpdates = false;

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
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create your PlayPadi account',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),
            CustomTextField(hintText: 'Full name', controller: nameController),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Phone number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: wantsUpdates,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      wantsUpdates = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'I want to stay updated with exclusive offers.',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Sign up',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.finalSteps);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
