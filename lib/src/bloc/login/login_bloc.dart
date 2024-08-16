import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/src/bloc/login/login_event.dart';
import 'package:instagram/src/bloc/login/login_state.dart';
import 'package:instagram/src/repository/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository = AuthRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginReqEvent>((event, emit) async {
      emit(LoginLoading());

      try {
        final emailOrUsername = event.emailoruser!;
        final password = event.password!;
        User? user;

        bool isEmail = emailOrUsername.contains('@');

        if (isEmail) {
          user = await authRepository.login(emailOrUsername, password);
        } else {
          user = await authRepository.loginWithUsername(emailOrUsername, password);
        }

        if (user != null) {
          final userModel = await authRepository.getUserData(user.uid);
          if (userModel != null) {
            emit(LoginSuccess(user: userModel));
          } else {
            emit(LoginError(error: 'User data not found'));
          }
        } else {
          emit(LoginError(error: 'Invalid email/username or password'));
        }
      } catch (e) {
        emit(LoginError(error: e.toString()));
      }
    });
  }
}
