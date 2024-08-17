import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/src/bloc/signup/signup_bloc.dart';
import 'package:instagram/src/bloc/signup/signup_event.dart';
import 'package:instagram/src/bloc/signup/signup_state.dart';
import '../../config/router/app_route.dart';
import '../../widgets/form_fields.dart'; // Import the form fields file
import '../../utils/validation.dart'; // Import the validation file

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController(); // Updated

  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode(); // Updated

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose(); // Updated
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fullNameFocusNode.dispose(); // Updated
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => SignupBloc(),
      child: Scaffold(
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              Navigator.pushNamed(context, AppRoutes.main);
            } else if (state is SignupError) {
              showValidationErrors(context, 'Signup failed: ${state.error}');
            }
          },
          builder: (context, state) {
            if (state is SignupLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: SizedBox(
                height: screenHeight,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: screenWidth * 0.2,
                            width: screenWidth * 0.2,
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.1,
                              bottom: screenHeight * 0.02,
                            ),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/instagram.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text(
                            'Instagram',
                            style: GoogleFonts.oleoScript(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                buildTextFormField(
                                  context: context,
                                  controller: _usernameController,
                                  focusNode: _usernameFocusNode,
                                  hintText: 'User Name',
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                buildTextFormField(
                                  context: context,
                                  controller: _fullNameController,
                                  focusNode: _fullNameFocusNode,
                                  hintText: 'Full Name', // Updated
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                buildTextFormField(
                                  context: context,
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  hintText: 'Email',
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                buildTextFormField(
                                  context: context,
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  hintText: 'Password',
                                  isPassword: true,
                                  isVisible: _isPasswordVisible,
                                  toggleVisibility: _togglePasswordVisibility,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                GestureDetector(
                                  onTap: () {
                                    if (validateSignupForm(
                                      context: context,
                                      usernameController: _usernameController,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      fullNameController:
                                          _fullNameController, // Updated
                                    )) {
                                      BlocProvider.of<SignupBloc>(context).add(
                                        SignupReqEvent(
                                          username:
                                              _usernameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                          fullName: _fullNameController.text
                                              .trim(), // Updated
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: screenHeight * 0.06,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.02),
                                      color: Colors.blue,
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.login),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
