import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soilapp/models/user.model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'users';
  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  // Get all users as a stream
  Stream<List<UserModel>> getAllUsers() {
    try {
      return _db.collection(collectionPath).snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => UserModel.fromDocumentSnapshot(doc))
              .toList());
    } catch (e) {
      print('Error getting users: $e');
      return Stream.empty();
    }
  }

  // Create a new user
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection(collectionPath).doc(uid).set(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  // Update a user
  Future<void> updateUser(UserModel user) async {
    try {
      await _db.collection(collectionPath).doc(uid).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final snapshot = await _db.collection("users").doc(uid).get();
        if (snapshot.exists) {
          return UserModel.fromMap(snapshot.data()!);
        }
      }
      return null;
    } catch (e) {
      print('Error getting current user $e');
      return null;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final snapshot = await _db.collection("users").doc(id).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }

      return null;
    } catch (e) {
      print('Error getting current user $e');
      return null;
    }
  }
}
