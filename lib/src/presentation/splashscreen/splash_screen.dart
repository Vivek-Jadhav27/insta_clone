import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/router/app_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (_auth.currentUser != null) {
      Navigator.pushNamed(context, AppRoutes.main);
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenWidth * 0.3,
              width: screenWidth * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/instagram.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            WidgetAnimator(
              incomingEffect: WidgetTransitionEffects(
                  delay: const Duration(milliseconds: 1200),
                  offset: const Offset(0, -30),
                  curve: Curves.easeInCubic,
                  duration: const Duration(milliseconds: 900)),
              atRestEffect: WidgetRestingEffects.wave(),
              child: Text(
                'Instagram',
                style: GoogleFonts.oleoScript(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
