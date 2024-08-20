import 'package:flutter/material.dart';
import '../config/models/post_model.dart';

class PostsGridView extends StatelessWidget {
  final List<PostModel> posts; 

  const PostsGridView({required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(post.imageUrls[0]), // Use the image URL from the post
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
