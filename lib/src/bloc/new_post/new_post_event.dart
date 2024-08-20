import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class NewPostEvent extends Equatable {}

class SubmitPostEvent extends NewPostEvent {
  final String caption;
  final List<File> selectedFiles;

  SubmitPostEvent({required this.caption, required this.selectedFiles});
  
  @override
  List<Object> get props => [caption, selectedFiles];
}

class CaptionChangedEvent extends NewPostEvent {
  final String caption;

  CaptionChangedEvent({required this.caption});

  @override
  List<Object> get props => [caption];
}
