import 'package:equatable/equatable.dart';
import 'package:instagram/src/config/models/user_model.dart';

abstract class LoginState extends Equatable{}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final UserModel user;
  
  LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final String error;
  
  LoginError({required this.error});

  @override
  List<Object?> get props => [error];
}