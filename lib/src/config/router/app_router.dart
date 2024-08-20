import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/src/bloc/add/add_bloc.dart';
// import 'package:instagram/src/presentation/home/edit_profile.dart';
import 'package:instagram/src/presentation/home/main_page.dart';
import 'package:instagram/src/presentation/home/profile_page.dart';
import 'package:instagram/src/presentation/splashscreen/splash_screen.dart';
import '../../bloc/new_post/new_post_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../models/route_model.dart';
import 'package:instagram/src/config/router/app_route.dart';
import '../../bloc/signup/signup_bloc.dart';
import '../../bloc/login/login_bloc.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/auth/login_page.dart';
import '../../presentation/auth/signup_page.dart';

class AppRouter {
  static List<AppRoute> routes() => [
        AppRoute(
          route: AppRoutes.main,
          view: const MainPage(),
        ),
        AppRoute(route: AppRoutes.splash, view: const SplashScreen()),
        AppRoute(
          route: AppRoutes.login,
          view: const LoginPage(),
        ),
        AppRoute(
          route: AppRoutes.signup,
          view: const SignupPage(),
        ),
        AppRoute(
          route: AppRoutes.profile,
          view: const ProfilePage(),
        ),
        // AppRoute(
        //   route: AppRoutes.editProfile,
        //   view: const EditProfile(),
        // ),
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
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => AddBloc()),
        BlocProvider(create: (context) => NewPostBloc()),
      ];
}
