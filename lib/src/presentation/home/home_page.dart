import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram/src/repository/post_repository.dart';
import '../../config/models/post_model.dart';
import '../../widgets/home_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<PostModel> posts = [];
  final PostRepository postRepository = PostRepository();

  @override
  void initState() {
    super.initState();

    postRepository.fetchPosts().then((value) {
      setState(() {
        posts.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Instagram',
            style: GoogleFonts.oleoScript(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {
              // Handle action
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length, // Number of posts
        itemBuilder: (context, index) {
          return HomePost(post: posts[index]);
        },
      ),
    );
  }
}
