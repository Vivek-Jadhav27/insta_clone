import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
        itemCount: 10, // Number of posts
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListTile(
              //   leading: CircleAvatar(
              //     backgroundImage: AssetImage('assets/images/user${index + 1}.jpg'), // Example profile image
              //   ),
              //   title: Text(
              //     'User ${index + 1}',
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
              //   trailing: IconButton(
              //     icon: const Icon(Icons.more_vert),
              //     onPressed: () {
              //       // Handle action
              //     },
              //   ),
              // ),
              // Container(
              //   height: 400, // Height of the post image
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/images/post${index + 1}.jpg'), // Example post image
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         icon: const Icon(Icons.favorite_border),
              //         onPressed: () {
              //           // Handle like
              //         },
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.chat_bubble_outline),
              //         onPressed: () {
              //           // Handle comment
              //         },
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.send),
              //         onPressed: () {
              //           // Handle share
              //         },
              //       ),
              //       const Spacer(),
              //       IconButton(
              //         icon: const Icon(Icons.bookmark_border),
              //         onPressed: () {
              //           // Handle save
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Text(
              //     'Liked by user${index + 1} and others',
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              //   child: Text(
              //     'View all comments',
              //     style: TextStyle(color: Colors.grey[600]),
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          );
        },
      ),
   );
  }
}
