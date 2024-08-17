import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/src/bloc/profile/profile_bloc.dart';
import 'package:instagram/src/bloc/profile/profile_event.dart';
import 'package:instagram/src/bloc/profile/profile_state.dart';
import 'package:instagram/src/config/models/user_model.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _usernameController;
  late TextEditingController _fullnameController;
  late TextEditingController _bioController;

  late FocusNode _usernameFocusNode;
  late FocusNode _fullnameFocusNode;
  late FocusNode _bioFocusNode;

  late UserModel userModel;
  bool _isInitialized = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _fullnameController = TextEditingController();
    _bioController = TextEditingController();

    _usernameFocusNode = FocusNode();
    _fullnameFocusNode = FocusNode();
    _bioFocusNode = FocusNode();

    BlocProvider.of<ProfileBloc>(context)
        .add(ProfileFetchingEvent(uid: widget.uid));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullnameController.dispose();
    _bioController.dispose();

    _usernameFocusNode.dispose();
    _fullnameFocusNode.dispose();
    _bioFocusNode.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${widget.uid} ${DateTime.now()}.jpg');
    try {
      await storageRef.putFile(_imageFile!);
      final downloadURL = await storageRef.getDownloadURL();
      _updateProfileImageUrl(downloadURL);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _updateProfileImageUrl(String url) {
    final updatedUserModel = userModel.copyWith(profileImageUrl: url);
    BlocProvider.of<ProfileBloc>(context)
        .add(ProfileUpdatingEvent(userModel: updatedUserModel));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdating) {
          // Optional: Show a loading indicator if needed
        } else if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
            ),
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          if (!_isInitialized) {
            userModel = state.userModel;
            _usernameController.text = state.userModel.username;
            _fullnameController.text = state.userModel.fullname;
            _bioController.text = state.userModel.bio;
            _isInitialized = true;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _updateProfile(context);
                      },
                      child: Text(
                        'Done',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: screenWidth * 0.30,
                          height: screenWidth * 0.30,
                          margin: EdgeInsets.only(
                            top: screenHeight * 0.01,
                            bottom: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            image: _imageFile != null
                                ? DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.fill,
                                  )
                                : const DecorationImage(
                                    image: AssetImage('assets/images/user.png'),
                                    fit: BoxFit.fill,
                                  ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Edit Profile Photo',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.01),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Username',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _usernameController,
                                    focusNode: _usernameFocusNode,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: 'Username',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Fullname',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _fullnameController,
                                    focusNode: _fullnameFocusNode,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: 'Fullname',
                                    ),
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.01),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Bio',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    minLines: 2,
                                    maxLines: 5,
                                    maxLength: 90,
                                    controller: _bioController,
                                    focusNode: _bioFocusNode,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'Bio',
                                    ),
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  void _updateProfile(BuildContext context) {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard

    final username = _usernameController.text.trim();
    final fullname = _fullnameController.text.trim();
    final bio = _bioController.text.trim();

    if (username.isEmpty || fullname.isEmpty || bio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required'),
        ),
      );
      return;
    }

    final updatedUserModel = userModel.copyWith(
      username: username,
      fullname: fullname,
      bio: bio,
    );

    _uploadImage();

    BlocProvider.of<ProfileBloc>(context).add(
      ProfileUpdatingEvent(userModel: updatedUserModel),
    );
  }
}
