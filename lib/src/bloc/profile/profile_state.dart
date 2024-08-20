import 'package:equatable/equatable.dart';
import 'package:instagram/src/config/models/post_model.dart';
import '../../config/models/user_model.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  final UserModel userModel;
  final Future<List<PostModel>> userPosts;
  ProfileLoaded(
      {required this.userModel, required  this.userPosts});

  @override
  List<Object?> get props => [userModel];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileUpdating extends ProfileState {
  @override
  List<Object?> get props => [];
}
