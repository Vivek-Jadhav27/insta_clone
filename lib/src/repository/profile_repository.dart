import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/src/config/models/user_model.dart';

class ProfileRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel> fetchProfile(String uid) async {
    try {
      final docSnapshot = await firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  Future<bool> updateProfile(UserModel userModel) async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        await firestore.collection('users').doc(uid).update(userModel.toJson());
        return true; 
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}
