import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/src/config/router/app_route.dart';
import 'package:instagram/src/presentation/home/add_new_post.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../bloc/add/add_bloc.dart';
import '../../bloc/add/add_event.dart';
import '../../bloc/add/add_state.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late AddBloc _addPageBloc;

  @override
  void initState() {
    super.initState();
    _addPageBloc = AddBloc();

    if (!(_addPageBloc.state is AddLoadedState ||
        _addPageBloc.state is MediaSelectionUpdatedState)) {
      _addPageBloc.add(FetchNewMediaEvent(album: null));
    }
  }

  @override
  void dispose() {
    _addPageBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int crossAxisCount = screenWidth > 600 ? 4 : 3;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(screenWidth),
      body: SafeArea(
        child: BlocConsumer<AddBloc, AddState>(
          bloc: _addPageBloc,
          listener: (context, state) {
            if (state is AlbumChangedState) {
              _addPageBloc.add(ChangeAlbumEvent(album: state.selectedAlbum));
            } else if (state is AddErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } else if (state is NavigateNextState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddNewPost(selectedFiles: state.selectedFiles)));
            }
          },
          builder: (context, state) {
            if (state is AddLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AddLoadedState ||
                state is MediaSelectionUpdatedState) {
              return _buildContent(
                  screenWidth, screenHeight, state, crossAxisCount);
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        },
        icon: Icon(
          Icons.close,
          color: Colors.black,
          size: screenWidth * 0.07,
        ),
      ),
      elevation: 0,
      title: Text(
        'New Post',
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.05),
            child: GestureDetector(
              onTap: () {
                _addPageBloc.add(NavigateNextEvent());
              },
              child: Text(
                'Next',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(double screenWidth, double screenHeight, AddState state,
      int crossAxisCount) {
    final isMediaSelectionState = state is MediaSelectionUpdatedState;

    final selectedFiles = isMediaSelectionState
        ? (state).selectedFiles
        : (state as AddLoadedState).selectedFiles;

    final mediaList = isMediaSelectionState
        ? (state).mediaList
        : (state as AddLoadedState).mediaList;

    final albums = isMediaSelectionState
        ? (state).albums
        : (state as AddLoadedState).albums;

    final selectedAlbum = isMediaSelectionState
        ? (state).selectedAlbum
        : (state as AddLoadedState).selectedAlbum;

    return Column(
      children: [
        Flexible(
          flex: 3,
          child: SizedBox(
            height: screenHeight * 0.50,
            child: selectedFiles.isNotEmpty
                ? PageView.builder(
                    itemCount: selectedFiles.length,
                    controller: PageController(viewportFraction: 1),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onDoubleTap: () {
                                print('Double-tap recognized');
                                _addPageBloc.add(RemoveFileEvent(
                                  file: selectedFiles[index],
                                  mediaList: mediaList,
                                  selectedAlbum: selectedAlbum,
                                  albums: albums,
                                ));
                              },
                              child: Image.file(
                                selectedFiles[index],
                                width: screenWidth,
                                height: screenHeight * 0.50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: screenHeight * 0.01,
                              left: screenWidth * 0.45,
                              child: Container(
                                width: screenWidth * 0.15,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.7),
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.05),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}/${selectedFiles.length}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No Image Selected',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
          ),
        ),
        Container(
          width: double.infinity,
          height: screenHeight * 0.05,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.03),
              DropdownButton<AssetPathEntity>(
                value: selectedAlbum,
                items: albums
                    .map((album) => DropdownMenuItem(
                          value: album,
                          child: Text(
                            album.name,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (AssetPathEntity? newAlbum) {
                  _addPageBloc.add(ChangeAlbumEvent(album: newAlbum!));
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: screenWidth * 0.01,
              crossAxisSpacing: screenWidth * 0.01,
            ),
            itemBuilder: (context, index) {
              return mediaList[index];
            },
          ),
        ),
      ],
    );
  }
}
