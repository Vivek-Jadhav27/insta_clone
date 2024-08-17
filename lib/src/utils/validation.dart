// validation.dart
import 'package:flutter/material.dart';

void showValidationErrors(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

bool validateSignupForm({
  required BuildContext context,
  required TextEditingController usernameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController fullNameController,
}) {
  final username = usernameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;
  final fullname = fullNameController.text;

  if (username.isEmpty) {
    showValidationErrors(context, 'Username cannot be empty');
    return false;
  }

  if (fullname.isEmpty) {
    showValidationErrors(context, 'Fullname cannot be empty');
    return false;
  }

  final emailRegex = RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (email.isEmpty || !emailRegex.hasMatch(email)) {
    showValidationErrors(context, 'Please enter a valid email address');
    return false;
  }

  final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
  if (password.isEmpty ||
      password.length < 6 ||
      !passwordRegex.hasMatch(password)) {
    showValidationErrors(context,
        'Password must be at least 6 characters long and contain both letters and numbers');
    return false;
  }

  return true;
}

bool validateLoginForm({
  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) {
  final email = emailController.text.trim();
  final password = passwordController.text;
  if (email.isEmpty) {
    showValidationErrors(context, 'Email cannot be empty');
    return false;
  }
  if (password.isEmpty) {
    showValidationErrors(context, 'Password cannot be empty');
    return false;
  }
  return true;
}
