import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String count;
  final double fontSize;

  const StatItem({
    required this.label,
    required this.count,
    required this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: fontSize * 1.125,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
