import 'package:flutter/material.dart';

class PostsGridView extends StatelessWidget {
  final int itemCount;

  const PostsGridView({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
        );
      },
      itemCount: itemCount,
    );
  }
}
