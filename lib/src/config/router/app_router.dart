import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/src/presentation/splash_screen.dart';
import '../models/route_model.dart';
import 'package:instagram/src/config/router/app_route.dart';

import '../../bloc/signup/signup_bloc.dart';
import '../../bloc/login/login_bloc.dart';

import '../../presentation/home_page.dart';
import '../../presentation/login_page.dart';
import '../../presentation/signup_page.dart';

class AppRouter {
  static List<AppRoute> routes() => [
        AppRoute(route: AppRoutes.splash, view: const SplashScreen()),
        AppRoute(
          route: AppRoutes.login,
          view: const LoginPage(),
        ),
        AppRoute(
          route: AppRoutes.signup,
          view: const SignupPage(),
        ),
      ];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => routes()
          .firstWhere(
            (element) => element.route == settings.name,
            orElse: () => AppRoute(
              route: AppRoutes.home,
              view: const HomePage(),
            ),
          )
          .view,
    );
  }

  static List allproviders() => [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SignupBloc()),
      ];
}
