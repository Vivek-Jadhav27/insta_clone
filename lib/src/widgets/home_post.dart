import 'package:flutter/material.dart';

import '../config/models/post_model.dart';

class HomePost extends StatelessWidget {
  final PostModel post;
  const HomePost({super.key, required this.post});

  void likePost() {}

  void commentPost() {}

  void sharePost() {}

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: post.userProfileImageUrl != ''
                    ? NetworkImage('${post.userProfileImageUrl}')
                    : AssetImage(
                        'assets/images/user.png'), // Example profile image
              ),
              title: Text(
                '${post.username}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
            Container(
                height: screenHeight * 0.3, // Height of the post image
                width: double.infinity,
                decoration: BoxDecoration(),
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: PageController(viewportFraction: 1),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Image.network(
                          '${post.imageUrls[index]}',
                          width: screenWidth,
                          fit: BoxFit.contain,
                        ),
                    itemCount: post.imageUrls.length)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Handle like
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      // Handle comment
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Handle share
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      // Handle save
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Liked by user  and others',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'View all comments',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ));
  }
}
