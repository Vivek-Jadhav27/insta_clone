import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../config/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future<User?> signup(String username, String email, String password) async {
    try {
      if (await isUsernameTaken(username)) {
        throw Exception('Username is already taken');
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Add user data to Firestore
        await firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'profileImageUrl': '',
          'bio': '',
          'followers': 0,
          'following': 0,
          'posts': 0,
          'followersList': [],
          'followingList': [],
          'postsList': [],
        });

        return user;
      }

      return null;
    } catch (e) {
      throw Exception('Error during signup: $e');
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<User?> loginWithUsername(String username, String password) async {
    try {
      // Step 1: Check if the username exists
      final querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Username not found');
      }

      // Step 2: Retrieve the associated email for the username
      final userDoc = querySnapshot.docs.first;
      final email = userDoc['email'] as String;

      // Step 3: Use the email to log in the user
      return await login(email, password);
    } catch (e) {
      throw Exception('Error during login with username: $e');
    }
  }
  
  Future<UserModel?> getUserData(String uid) async {
    try {
      final docSnapshot = await firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking username availability: $e');
    }
  }

}
