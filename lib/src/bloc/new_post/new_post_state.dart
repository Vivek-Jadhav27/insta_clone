import 'package:equatable/equatable.dart';

abstract class NewPostState extends Equatable {}

class NewPostInitialState extends NewPostState {
  @override
  List<Object?> get props => [];
}

class NewPostLoadingState extends NewPostState {
  @override
  List<Object?> get props => [];
}

class NewPostSuccessState extends NewPostState {
  
  @override
  List<Object?> get props => [];
}

class NewPostErrorState extends NewPostState {
  final String message;

  NewPostErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class CaptionUpdated extends NewPostState {
  final String caption;

  CaptionUpdated({required this.caption});

  @override
  List<Object> get props => [caption];
}
