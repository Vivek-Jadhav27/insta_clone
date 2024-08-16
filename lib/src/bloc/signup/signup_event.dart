import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {}

class SignupReqEvent extends SignupEvent {
  
  final String? username;
  final String? email;
  final String? password;
  
  SignupReqEvent({this.username, this.email, this.password});

  @override
  List<Object?> get props => [username , email, password];
}
