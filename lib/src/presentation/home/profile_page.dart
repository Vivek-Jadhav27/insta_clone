import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/src/bloc/profile/profile_bloc.dart';
import 'package:instagram/src/bloc/profile/profile_event.dart';
import 'package:instagram/src/bloc/profile/profile_state.dart';
import 'package:instagram/src/presentation/home/edit_profile.dart';
import 'package:instagram/src/widgets/stat_item.dart';
import 'package:instagram/src/widgets/story_view.dart';
import '../../widgets/posts_grid_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late String userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userId = FirebaseAuth.instance.currentUser!.uid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(ProfileFetchingEvent(uid: userId));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Center(
                child: Text(
                  state.userModel
                      .username, // Display the username from userModel
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }
            return Center(
              child: Text(
                'Profile',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.menu, size: screenWidth * 0.08, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(state.message, style: TextStyle(color: Colors.red)),
              ),
            );
          } else if (state is ProfileUpdated) {
            context.read<ProfileBloc>().add(ProfileFetchingEvent(uid: userId));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final userModel = state.userModel;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth * 0.20,
                          height: screenWidth * 0.20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: userModel.profileImageUrl.isNotEmpty
                                  ? NetworkImage(userModel.profileImageUrl)
                                  : AssetImage('assets/images/user.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                        StatItem(
                          label: 'Posts',
                          count: "${userModel.posts}",
                          fontSize: screenWidth * 0.04,
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Follow')),
                            );
                          },
                          child: StatItem(
                            label: 'Followers',
                            count: "${userModel.followers}",
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Following')),
                            );
                          },
                          child: StatItem(
                            label: 'Following',
                            count: "${userModel.following}",
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.fullname,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userModel.bio,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: screenWidth * 0.040,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.02,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                      uid: userId,
                                    )));
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.01),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: SizedBox(
                      height: screenWidth * 0.22,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1, //Highlights Count
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return StoryView("New");
                          }
                          return StoryView("Story ${index + 1}");
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(icon: Icon(Icons.grid_on, color: Colors.black)),
                        Tab(
                            icon: Icon(Icons.bookmark_border,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.65,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PostsGridView(itemCount: userModel.posts),
                        PostsGridView(itemCount: 0),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
