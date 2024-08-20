import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/src/bloc/new_post/new_post_bloc.dart';
import '../../bloc/new_post/new_post_event.dart';
import '../../bloc/new_post/new_post_state.dart';
import '../../config/router/app_route.dart';

class AddNewPost extends StatefulWidget {
  final List<File> selectedFiles;
  const AddNewPost({super.key, required this.selectedFiles});

  @override
  State<AddNewPost> createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  TextEditingController _captionController = TextEditingController();
  FocusNode _captionFocusNode = FocusNode();

  @override
  void dispose() {
    _captionController.dispose();
    _captionFocusNode.dispose();
    super.dispose();
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => NewPostBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'New Post',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<NewPostBloc, NewPostState>(
          listener: (context, state) {
            if (state is NewPostLoadingState) {
              // Optionally, you can show a loading indicator or something here
            } else if (state is NewPostSuccessState) {
              _showSnackBar('Post added successfully');
              Navigator.pushNamed(context, AppRoutes.main); // Navigate back after posting
            } else if (state is NewPostErrorState) {
              _showSnackBar('Failed to add post: ${state.message}');
            }
          },
          builder: (context, state) {
            if (state is NewPostLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SafeArea(
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: SizedBox(
                      height: screenHeight * 0.40,
                      child: widget.selectedFiles.isNotEmpty
                          ? PageView.builder(
                              itemCount: widget.selectedFiles.length,
                              controller: PageController(viewportFraction: 1),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02),
                                  child: Stack(
                                    children: [
                                      Image.file(
                                        widget.selectedFiles[index],
                                        width: screenWidth,
                                        height: screenHeight * 0.50,
                                        fit: BoxFit.contain,
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
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.01),
                    child: TextField(
                      minLines: 3,
                      maxLines: 8,
                      maxLength: 150,
                      keyboardType: TextInputType.multiline,
                      controller: _captionController,
                      focusNode: _captionFocusNode,
                      decoration: InputDecoration(
                          hintText: 'Caption',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                  Spacer(), // Pushes the Post button to the bottom

                  GestureDetector(
                    onTap: () {
                      context.read<NewPostBloc>().add(SubmitPostEvent(
                        selectedFiles: widget.selectedFiles,
                        caption: _captionController.text,
                      ));
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      child: Center(
                        child: Text(
                          'Post',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
