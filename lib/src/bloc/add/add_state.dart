import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class AddState extends Equatable {}

class AddInitialState extends AddState {
  @override
  List<Object?> get props => [];
}

class AddLoadingState extends AddState {
  @override
  List<Object?> get props => [];
}

class AddLoadedState extends AddState {
  final List<Widget> mediaList;
  final List<File> selectedFiles;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;

  AddLoadedState(
      {required this.mediaList,
      required this.selectedAlbum,
      required this.selectedFiles,
      required this.albums});

  @override
  List<Object?> get props => [mediaList, albums, selectedAlbum, selectedFiles];
}

class MediaSelectionUpdatedState extends AddState {
  final List<Widget> mediaList;
  final List<File> selectedFiles;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;

  MediaSelectionUpdatedState(
      {required this.mediaList,
      required this.selectedFiles,
      required this.albums,
      required this.selectedAlbum});

  @override
  List<Object?> get props => [mediaList, selectedFiles, albums, selectedAlbum];
}

class AlbumChangedState extends AddState {
  final List<Widget> mediaList;
  final List<File> selectedFiles;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;

  AlbumChangedState({
    required this.mediaList,
    required this.selectedFiles,
    required this.albums,
    required this.selectedAlbum,
  });

  @override
  List<Object?> get props => [mediaList, albums, selectedAlbum, selectedFiles];
}

class AddErrorState extends AddState {
  final String message;
  AddErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class NavigateNextState extends AddState {
  final List<File> selectedFiles;
  NavigateNextState({required this.selectedFiles});

  @override
  List<Object?> get props => [selectedFiles];
}
