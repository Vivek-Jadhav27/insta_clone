
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginReqEvent extends LoginEvent {
  final String? emailoruser;
  final String? password;
  
  LoginReqEvent({
    required this.emailoruser,
    required this.password,});

  @override
  List<Object?> get props => [emailoruser, password];
}
