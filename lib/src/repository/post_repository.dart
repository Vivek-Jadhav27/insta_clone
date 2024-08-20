import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/src/config/models/post_model.dart';
import 'package:instagram/src/config/models/user_model.dart';
import 'profile_repository.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ProfileRepository profileRepository = ProfileRepository();

  Future<void> addPost(String caption, List<File> files) async {
    
    String userID = FirebaseAuth.instance.currentUser!.uid;
    UserModel userModel = await profileRepository.fetchProfile(userID);

    List<String> imageUrls = await _uploadFiles(files);

    PostModel post = PostModel(
      caption: caption,
      imageUrls: imageUrls,
      createAt: DateTime.now().toIso8601String(),
      id: '', // To be updated after document creation
      userId: userID,
      username: userModel.username,
      userProfileImageUrl: userModel.profileImageUrl,
    );

    // Add post to Firestore and get the document ID
    DocumentReference docRef =
        await _firestore.collection('posts').add(post.toJson());
    String postId = docRef.id;

    // Update post ID in the post object
    await docRef.update({
      'id': postId,
    });

    // Update user profile
    await _firestore.collection('users').doc(userID).update({
      'posts': FieldValue.increment(1),
      'postsList': FieldValue.arrayUnion([postId]),
    });
  }

  Future<List<String>> _uploadFiles(List<File> files) async {
    List<String> fileUrls = [];
    try {
      for (File file in files) {
        Reference ref = _storage.ref().child(
            'posts/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}');
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();
        fileUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error uploading files: $e');
      rethrow;
    }
    return fileUrls;
  }

  Future<List<PostModel>> fetchPosts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('posts').get();
    List<PostModel> posts =
        snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();

    print(posts);
    return posts;
  }

  Future<List<PostModel>> fetchUserPosts(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(userID).get();
    List<String> postIds =
        List<String>.from(userDoc.data()?['postsList'] ?? []);

    List<PostModel> posts = [];
    for (String postId in postIds) {
      DocumentSnapshot<Map<String, dynamic>> postDoc =
          await _firestore.collection('posts').doc(postId).get();
      if (postDoc.exists) {
        posts.add(PostModel.fromJson(postDoc.data()!));
      }
    }
    return posts;
  }
}
