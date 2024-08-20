import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'add_event.dart';
import 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  List<Widget> _mediaThumbnails = []; // Stores thumbnail widgets of media files
  List<File> _mediaFiles = []; // Stores the actual media files (images)
  List<File> _selectedMediaFiles =
      []; // Stores the media files selected by the user
  List<AssetPathEntity> _availableAlbums =
      []; // Stores the albums available on the device
  AssetPathEntity? _currentAlbum; // The album currently selected by the user
  int _currentPageIndex = 0; // Keeps track of the current page for pagination
  int _maxMediaSelection =
      5; // Maximum number of media files that can be selected
  File? _defaultSelectedFile; // Default file that is pre-selected initially

  AddBloc() : super(AddInitialState()) {
    on<FetchNewMediaEvent>(_loadmedia);
    on<SelectFileEvent>(_selectfile);
    on<RemoveFileEvent>(_removefile);
    on<ChangeAlbumEvent>(_changealbum);
    on<NavigateNextEvent>(_onNavigateNextEvent);
  }
  void _loadmedia(
    FetchNewMediaEvent event,
    Emitter<AddState> emit,
  ) async {
    emit(AddInitialState());

    emit(AddLoadingState());

    try {
      final PermissionState permissionStatus =
          await PhotoManager.requestPermissionExtend();
      if (permissionStatus.isAuth) {
        if (_availableAlbums.isEmpty) {
          _availableAlbums =
              await PhotoManager.getAssetPathList(type: RequestType.image);
          _currentAlbum =
              _availableAlbums.isNotEmpty ? _availableAlbums[0] : null;
        }

        if (event.album != null) _currentAlbum = event.album;

        if (_currentAlbum == null) {
          emit(AddErrorState(message: 'No album available'));
          return;
        }

        _currentPageIndex = 0;
        _mediaFiles.clear();
        _mediaThumbnails.clear();
        _selectedMediaFiles.clear();

        List<AssetEntity> mediaAssets = await _currentAlbum!
            .getAssetListPaged(page: _currentPageIndex, size: 60);

        if (mediaAssets.isEmpty) {
          emit(AddErrorState(message: 'No media found in this album'));
          return;
        }

        for (var asset in mediaAssets) {
          if (asset.type == AssetType.image) {
            final file = await asset.file;
            if (file != null) {
              _mediaFiles.add(File(file.path));
              if (_selectedMediaFiles.isEmpty) {
                _defaultSelectedFile = File(file.path);
                _selectedMediaFiles.add(_defaultSelectedFile!);
              }
            }
          }
        }

        List<Widget> thumbnailWidgets = [];
        for (var asset in mediaAssets) {
          thumbnailWidgets.add(
            FutureBuilder(
              future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onTap: () {
                      add(
                        SelectFileEvent(
                          file: _mediaFiles[mediaAssets.indexOf(asset)],
                          mediaList: _mediaThumbnails,
                          albums: _availableAlbums,
                          selectedAlbum: _currentAlbum!,
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        }

        _mediaThumbnails.addAll(thumbnailWidgets);
        _currentPageIndex++;

        emit(AddLoadedState(
          mediaList: _mediaThumbnails,
          selectedFiles: _selectedMediaFiles,
          albums: _availableAlbums,
          selectedAlbum: _currentAlbum!,
        ));
      } else {
        emit(AddErrorState(message: 'Permission denied'));
      }
    } catch (e) {
      emit(AddErrorState(message: 'Failed to load media: $e'));
    }
  }

  void _selectfile(
    SelectFileEvent event,
    Emitter<AddState> emit,
  ) async {
    try {
      if (_selectedMediaFiles.contains(_defaultSelectedFile!) &&
          _selectedMediaFiles.length == 1) {
        _selectedMediaFiles.remove(_defaultSelectedFile!);
        _selectedMediaFiles.add(event.file);
      } else if (_selectedMediaFiles.contains(event.file)) {
        _selectedMediaFiles.remove(event.file);
      } else if (_selectedMediaFiles.length < _maxMediaSelection) {
        _selectedMediaFiles.add(event.file);
      } else {
        emit(AddErrorState(message: 'Max selection limit reached'));
      }
      emit(AddLoadingState());

      emit(MediaSelectionUpdatedState(
        mediaList: event.mediaList,
        selectedFiles: _selectedMediaFiles,
        selectedAlbum: event.selectedAlbum,
        albums: event.albums,
      ));
    } catch (e) {
      emit(AddErrorState(message: 'Error selecting file: $e'));
    }
  }

  void _removefile(
    RemoveFileEvent event,
    Emitter<AddState> emit,
  ) {
    try {
      if (_selectedMediaFiles.any((f) => f.path == event.file.path)) {
        _selectedMediaFiles.removeWhere((f) => f.path == event.file.path);
        print("File removed: ${event.file.path}");

        emit(AddLoadingState());

         emit(MediaSelectionUpdatedState(
            mediaList: event.mediaList,
            selectedFiles: _selectedMediaFiles,
            selectedAlbum: event.selectedAlbum,
            albums: event.albums,
          ));


        if (_selectedMediaFiles.isEmpty) {
          emit(AddLoadedState(
            mediaList: event.mediaList,
            selectedFiles: _selectedMediaFiles,
            selectedAlbum: event.selectedAlbum,
            albums: event.albums,
          ));
        } else {
          emit(MediaSelectionUpdatedState(
            mediaList: event.mediaList,
            selectedFiles: _selectedMediaFiles,
            selectedAlbum: event.selectedAlbum,
            albums: event.albums,
          ));
        }
      } else {
        emit(AddErrorState(message: 'File not found in selection'));
      }
    } catch (e) {
      emit(AddErrorState(message: 'Error removing file: $e'));
    }
  }

  void _changealbum(
    ChangeAlbumEvent event,
    Emitter<AddState> emit,
  ) {
    try {
      add(FetchNewMediaEvent(album: event.album));
    } catch (e) {
      emit(AddErrorState(message: 'Error changing album: $e'));
    }
  }

  void _onNavigateNextEvent(
    NavigateNextEvent event,
    Emitter<AddState> emit,
  ) {
    try {
      if (_selectedMediaFiles.isNotEmpty) {
        emit(NavigateNextState(selectedFiles: _selectedMediaFiles));
      } else {
        emit(AddErrorState(message: 'No media files selected'));
      }
    } catch (e) {
      emit(AddErrorState(message: 'Error navigating to next: $e'));
    }
  }
}
