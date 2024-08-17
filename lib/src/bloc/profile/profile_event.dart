import 'package:equatable/equatable.dart';
import 'package:instagram/src/config/models/user_model.dart';

abstract class ProfileEvent extends Equatable {}

class ProfileFetchingEvent extends ProfileEvent {
  final String uid;

  ProfileFetchingEvent({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class ProfileUpdatingEvent extends ProfileEvent {
  final UserModel userModel;

  ProfileUpdatingEvent({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}