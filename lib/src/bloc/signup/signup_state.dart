import 'package:equatable/equatable.dart';
import 'package:instagram/src/config/models/user_model.dart';

abstract class SignupState extends Equatable {}

class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupSuccess extends SignupState {
  
  final UserModel user;
  SignupSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class SignupError extends SignupState {
  final String? error;

  SignupError({this.error});

  @override
  List<Object?> get props => [error];
} 

