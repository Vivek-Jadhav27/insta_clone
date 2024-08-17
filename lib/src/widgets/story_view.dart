import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryView extends StatelessWidget {
  final String title; // Add a field to store the title

  const StoryView(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Handle highlight item click
      },
      child: Padding(
        padding: EdgeInsets.only(right: screenWidth * 0.04),
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Center(
                child: Icon(Icons.add, size: screenWidth * 0.08),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
