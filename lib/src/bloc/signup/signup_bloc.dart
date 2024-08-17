import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/src/bloc/signup/signup_event.dart';
import 'package:instagram/src/bloc/signup/signup_state.dart';
import 'package:instagram/src/repository/auth_repository.dart';


class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository = AuthRepository();

  SignupBloc() : super(SignupInitial()) {
    on<SignupReqEvent>((event, emit) async {
      emit(SignupLoading());

      try {
        final user = await authRepository.signup(
          event.username!,
          event.email!,
          event.password!,
          event.fullName!,
        );

        if (user != null) {
          final userModel = await authRepository.getUserData(user.uid);

          if (userModel != null) {
            emit(SignupSuccess(user: userModel));
          } else {
            emit(SignupError(error: 'Failed to retrieve user data'));
          }
        } else {
          emit(SignupError(error: 'Signup failed'));
        }
      } catch (e) {
        emit(SignupError(error: e.toString()));
      }
    });
  }
}
