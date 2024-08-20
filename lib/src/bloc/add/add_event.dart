import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class AddEvent extends Equatable {}

class FetchNewMediaEvent extends AddEvent {
  final AssetPathEntity? album;
  FetchNewMediaEvent({required this.album});

  @override
  List<Object?> get props => [album];
}

class SelectFileEvent extends AddEvent {
  final List<Widget> mediaList;
  final File file;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;

  SelectFileEvent(
      {required this.mediaList,
      required this.file,
      required this.albums,
      required this.selectedAlbum});

  @override
  List<Object?> get props => [file, selectedAlbum, albums, mediaList];
}

class RemoveFileEvent extends AddEvent {
  final List<Widget> mediaList;
  final File file;
  final List<AssetPathEntity> albums;
  final AssetPathEntity selectedAlbum;

  RemoveFileEvent(
      {required this.mediaList,
      required this.file,
      required this.albums,
      required this.selectedAlbum});

  @override
  List<Object?> get props => [file];
}

class ChangeAlbumEvent extends AddEvent {
  final AssetPathEntity album;
  ChangeAlbumEvent({required this.album});

  @override
  List<Object> get props => [album];
}

class NavigateNextEvent extends AddEvent {
  @override
  List<Object?> get props => [];
}
