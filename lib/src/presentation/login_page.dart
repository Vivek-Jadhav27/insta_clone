import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/src/bloc/login/login_event.dart';
import 'package:instagram/src/bloc/login/login_state.dart';
import '../utils/validation.dart';
import '../widgets/form_fields.dart';
import '../bloc/login/login_bloc.dart';
import '../config/router/app_route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushNamed(context, AppRoutes.home);
            }
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: screenWidth * 0.2,
                                width: screenWidth * 0.2,
                                margin: EdgeInsets.only(top: screenHeight * 0.1, bottom: screenHeight * 0.02),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/instagram.png'),
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
                              buildTextFormField(
                                context: context,
                                controller: _usernameController,
                                focusNode: _usernameFocusNode,
                                hintText: 'Email or UserName',
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
                                  if (validateLoginForm(
                                    context: context,
                                    emailController: _usernameController,
                                    passwordController: _passwordController,
                                  )) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                      LoginReqEvent(
                                        emailoruser: _usernameController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: screenHeight * 0.06,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.06,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle forgot password logic
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
                    },
                    child: Container(
                      height: screenHeight * 0.06,
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: screenWidth * 0.04,
                          right: screenWidth * 0.04,
                          bottom: screenHeight * 0.04),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(screenWidth * 0.05),
                          border: Border.all(color: Colors.blue)),
                      child: Center(
                        child: Text(
                          'Create New Account',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.normal,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
