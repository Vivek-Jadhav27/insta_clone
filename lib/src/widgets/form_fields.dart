// form_fields.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDecoration({
  required BuildContext context,
  required String hintText,
  bool isPassword = false,
  bool isVisible = false,
  VoidCallback? toggleVisibility,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  return InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.poppins(
      fontSize: screenWidth * 0.04,
      fontWeight: FontWeight.normal,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(screenWidth * 0.05),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(screenWidth * 0.05),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    suffixIcon: isPassword
        ? IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          )
        : null,
  );
}

Widget buildTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required FocusNode focusNode,
  required String hintText,
  bool isPassword = false,
  bool isVisible = false,
  VoidCallback? toggleVisibility,
  
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    obscureText: isPassword && !isVisible,

    decoration: inputDecoration(
      context: context,
      hintText: hintText,
      isPassword: isPassword,
      isVisible: isVisible,
      toggleVisibility: toggleVisibility,
    ),
    style: GoogleFonts.poppins(
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontWeight: FontWeight.normal,
    ),
  );
}
